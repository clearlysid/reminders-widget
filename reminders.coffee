# Widget Settings
settings =
  tasksPerList: 0 # Number of tasks to show per list, 0 for all
  listToShow: "Today's Focus"
  refreshFrequency: '6000' #milliseconds

refreshFrequency: settings.refreshFrequency
command: 'reminders-widget/tasks.sh'

# CSS styling for the widget
setStyle: (output) ->
  settings.style = output

# Widget update behavior
update: (output, domEl) ->
    str = '<div class="lists">'
    listNameTpl = ''
    reminders = JSON.parse(output)
    listTasks = @tasksByList(output)
    if !@content
        @content = $(domEl).children('#reminders-wrapper').html(str)
    		if listName = settings.listToShow
                n = 0
                if listTasks[listName]? # if tasks exist
                    n = if settings.tasksPerList > 0 and listTasks[listName].length > settings.tasksPerList then settings.tasksPerList else listTasks[listName].length
                if n > 0 # if there are tasks in the list
                    listNameTpl = '<h>' + listName + '</h>'
                    str +=  '<div class="list">' + listNameTpl + '<ul class="tasks">'

                    i = 0
                    for task in listTasks[listName]
                        if i < n
                            task = listTasks[listName][i]
                            str += '<li class="task">' + task.title + '</li>'
                            i++
                        else
                            break
                    str += '</ul></div>'
    str += '</div>'
    @content.html(str)

tasksByList: (output) ->
    reminders = JSON.parse(output)
    listTasks = {}
    for t in reminders.tasks
        listTasks[t.list] = [] if !listTasks[t.list]
        listTasks[t.list].push(t)
    return listTasks

# Wrapper div
render: (_) -> """
	<div id='reminders-wrapper'>
	</div>
"""

# CSS styling for the widget
style: """
  top: 50%
  color: #fff
  font-family: Helvetica Neue
  display: flex
  flex-direction: column
  width: 100%
  align-items: center

  h
    text-align: center
    font-size: 32px
    font-weight: 100

  .list
    font-size: 16px
    font-weight: 100
    letter-spacing: 1px
  
  ul
    padding-left: 20px
    list-style-type: circle

  .completed
    color: #888
    font-weight: 100
    text-decoration:line-through
"""