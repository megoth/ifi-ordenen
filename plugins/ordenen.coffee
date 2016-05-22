_ = require 'underscore'

module.exports = (env, callback) ->
  # *env* is the current wintersmith environment
  # *callback* should be called when the plugin has finished loading
  
  getYears = (contents) ->
    events = contents.history._.directories.map (item) -> item.index
    firstYear = (events.sort (docA, docB) -> if docA.metadata.year < docB.metadata.year then -1 else 1)[0].metadata.year
    lastYear = (new Date()).getFullYear()
    
    currentTitles = _(contents.person._.directories.map (item) -> item.index).filter (item) -> item.metadata.current
    previousTitles = _(contents.person._.directories.map (item) -> item._.directories.map (subitem) -> {
      title: subitem.index.title,
      metadata: subitem.index.metadata,
      url: item.index.url+'#'+subitem.index.metadata.current
    }).flatten()
    persons = currentTitles.concat(previousTitles)
    personHierarchy = contents['structure.json'].metadata.persons
    titleHierarchy = contents['structure.json'].metadata.titles.hierarchy.map (title) -> getTitle(title, personHierarchy)
     
    years = []
    for i in [firstYear...lastYear+1]
      years.push(getYear(i, events, persons, titleHierarchy))
    _(years).filter (year) -> year.events.length > 0 or _(year.appointments.map (appointment) -> appointment.persons).flatten().length > 0
  
  getYear = (year, events, persons, hierarchy) ->
    { 
      year: year, 
      events: ((_(events).filter (event) -> event.metadata.year is year).sort (docA, docB) -> 
        if docA.date.getTime() and docB.date.getTime() then (if docA.date > docB.date then 1 else -1) else (if docA.date.getTime() and !docB.date.getTime() then -10 else (if docA.title < docB.title then -1 else 1))),
      appointments: (hierarchy.map (title) -> getAppointments year, title, persons)
    }
  
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
    (_(years.map (year) -> year.events.map (event) -> event.metadata.sources).chain().flatten().uniq().value().filter (source) -> source).forEach (source, index) ->
      key = (source.split ' ')[0]
      references[key] = {
        html: getSource(source),
        index: index + 1
      }
    references
  
  # add helpers to the environment so we can use it later
  env.helpers.getReferences = getReferences
  env.helpers.getSources = getSources
  env.helpers.getYear = getYear
  env.helpers.getYears = getYears

  # tell plugin manager we are done
  callback()