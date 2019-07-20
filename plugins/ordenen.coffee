_ = require 'underscore'
moment = require 'moment'

# *env* is the current wintersmith environment
# *callback* should be called when the plugin has finished loading

module.exports = (env, callback) ->
  getYears = (contents) ->
    events = contents.history._.directories.map (item) -> item.index
    firstYear = (events.sort (docA, docB) -> if docA.metadata.year < docB.metadata.year then -1 else 1)[0].metadata.year
    lastYear = (new Date()).getFullYear()

    currentTitles = _(contents.person._.directories.map (item) -> item.index).filter (item) -> item.metadata.current
    previousTitles = _(contents.person._.directories.map (item) -> item._.directories.map (subitem) -> {
      title: subitem.index.title,
      metadata: subitem.index.metadata,
      url: item.index.url + '#' + subitem.index.metadata.current
    }).flatten()
    persons = currentTitles.concat(previousTitles)
    personHierarchy = contents['structure.json'].metadata.persons
    titleHierarchy = contents['structure.json'].metadata.titles.hierarchy.map (title) -> getTitle(title, personHierarchy)

    years = []
    for i in [lastYear...firstYear - 1]
      years.push(getYear(i, events, persons, titleHierarchy))
    _(years).filter (year) -> (year.events.concat year.minor).length > 0 or _(year.appointments.map (appointment) -> appointment.persons).flatten().length > 0

  getYear = (year, events, persons, hierarchy) ->
    {
      year: year,
      events: getEvents(events, year, false),
      appointments: (hierarchy.map (title) -> getAppointments year, title, persons),
      minor: getEvents(events, year, true)
    }

  getEvents = (events, year, minor) ->
    (_(events).filter (event) -> event.metadata.year is year and (if minor then (event.metadata.tags.indexOf 'minor') isnt -1 else (event.metadata.tags.indexOf 'minor') is -1)).sort (docA, docB) -> getSortValue(docA) > getSortValue(docB)

  getSortValue = (doc) -> getTime(doc.date, doc.metadata.year) + doc.title
  getTime = (date, year) -> if date.getTime() is 0 then moment([year, 11, 31]).toDate().getTime() else date.getTime()

  getAppointments = (year, title, persons) ->
    {
      title: title.name,
      persons: _(persons).filter (person) -> person.metadata.appointed is year and person.metadata.current is title.title
    }

  getTitle = (title, personHierarchy) ->
    {
      title: title,
      name: (_(personHierarchy.structure).find (insignia) -> insignia.title is title).name
    }

  getSources = (sources, references) ->
    sources.map (source) -> getSource source, references

  getSource = (source, references) ->
    if source.match(/http/)
      sourceParts = source.split ' '
      sourceUrl = sourceParts[0]
      if references and references[sourceUrl]
        "<a href=\"\##{references[sourceUrl].index}\">#{references[sourceUrl].index}</a>"
      else
        sourceParts.shift()
        sourceName = sourceParts.join ' '
        "<a href=\"#{sourceUrl}\">#{sourceName}</a>"
    else
      source

  getReferences = (contents) ->
    years = getYears(contents)
    references = {}
    (_(years.map (year) -> (year.events.concat year.minor).map (event) -> event.metadata.sources).chain().flatten().uniq().value().filter (source) -> source).forEach (source, index) ->
      key = (source.split ' ')[0]
      references[key] = {
        html: getSource(source),
        index: index + 1
      }
    references

  getReferencesForHistory = (years) ->
    references = {}
    (_(years.map (year) -> (year.events.concat year.minor).map (event) -> event.metadata.sources).chain().flatten().uniq().value().filter (source) -> source).forEach (source, index) ->
      key = (source.split ' ')[0]
      references[key] = {
        html: getSource(source),
        index: index + 1
      }
    references

  getClassesForEvents = (events) ->
    _(events.map (event) -> if event.metadata.tags then event.metadata.tags.split(', ') else []).flatten()

  getClassesForYear = (year) ->
    eventTags = _(year.events.map (event) -> if event.metadata.tags then event.metadata.tags.split(', ') else []).flatten()
    appointmentTags = if _(year.appointments.map (appointment) -> appointment.persons).flatten().length > 0 then ['ifi-ordenen'] else []
    minorTags = _(year.minor.map (event) -> if event.metadata.tags then event.metadata.tags.split(', ') else []).flatten()
    _(eventTags.concat(appointmentTags).concat(minorTags)).uniq().map (tag) -> "year-#{tag}"

  populatePersonObject = (person) ->
    usernameParts = person.filepath.relative.split('/')
    username = usernameParts[usernameParts.length - 2]
    Object.assign({ username }, person)

  getPersonThumb = (locals, username) ->
    getPersonUrl(locals, username) + '/thumb.jpg'

  getPersonUrl = (locals, username) ->
    locals.url + '/person/' + username

  getPersonsForTag = (contents, tag) ->
    (
      contents.person._.directories
        .map (person) -> person.index
        .filter (person) -> ((if person.metadata.associations then person.metadata.associations.split(', ').indexOf tag else -1) isnt -1)
        .map (person) -> populatePersonObject(person)

    )
      .sort (docA, docB) -> if getSortValueForPerson(docA) < getSortValueForPerson(docB) then 1 else -1

  getSortValueForPerson = (person) ->
    10000 * getSortValueForInsignia(person.metadata.current) - person.metadata.appointed

  getSortValueForInsignia = (insignia) ->
    switch insignia
      when 'grand_cross' then 10000
      when 'commander_with_star' then 8000
      when 'commander' then 6000
      when 'knight_first_class' then 4000
      when 'knight' then 2000
      else
        0

  getYearsForTag = (contents, tag) ->
    events = (contents.history._.directories.map (event) -> event.index).filter (event) ->
      ((if event.metadata.tags then event.metadata.tags.split(', ') else []).indexOf tag) isnt -1
    if events.length > 0
      firstYear = (events.sort (docA, docB) -> if docA.metadata.year < docB.metadata.year then -1 else 1)[0].metadata.year
      lastYear = (new Date()).getFullYear()
      years = []
      for i in [lastYear...firstYear - 1]
        years.push(getYear(i, events, [], []))
      _(years).filter (year) -> (year.events.concat year.minor).length > 0 or _(year.appointments.map (appointment) -> appointment.persons).flatten().length > 0
    else
      []

  getTitleName = (contents, title) ->
    contents.title[title].index.title

  getUsername = (page) ->
    parts = page.filepath.relative.split('/')
    parts[parts.length - 2]

  getAssociation = (contents, associationTag) ->
    if contents.association[associationTag] then contents.association[associationTag].index else null

  getAssociations = (contents, active) ->
    contents.association._.directories
      .map (associationDirective) -> associationDirective.index
      .filter (association) -> association.metadata.active == active
      .sort (docA, docB) -> if docA.title.toLowerCase() < docB.title.toLowerCase() then -1 else 1

  sortArticles = (articles) ->
    articles.sort (artA, artB) -> if artA.date > artB.date then -1 else 1

  # add helpers to the environment so we can use it later
  env.helpers.getAssociation = getAssociation
  env.helpers.getAssociations = getAssociations
  env.helpers.getClassesForEvents = getClassesForEvents
  env.helpers.getClassesForYear = getClassesForYear
  env.helpers.getPersonThumb = getPersonThumb
  env.helpers.getPersonUrl = getPersonUrl
  env.helpers.getPersonsForTag = getPersonsForTag
  env.helpers.getReferences = getReferences
  env.helpers.getReferencesForHistory = getReferencesForHistory
  env.helpers.getSortValue = getSortValue
  env.helpers.getSources = getSources
  env.helpers.getTitleName = getTitleName
  env.helpers.getUsername = getUsername
  env.helpers.getYear = getYear
  env.helpers.getYears = getYears
  env.helpers.getYearsForTag = getYearsForTag
  env.helpers.sortArticles = sortArticles

  # tell plugin manager we are done
  callback()