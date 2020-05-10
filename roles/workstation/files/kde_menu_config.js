var panel = panels()[1]
panel.hiding = 'autohide'
var taskmanager = panel.widgets('org.kde.plasma.taskmanager')[0]
if (taskmanager) {
    print(taskmanager.launchers)
    panel.addWidget('org.kde.plasma.icontasks', 64, 0)
    taskmanager.remove()
}
var iconmanager = panel.widgets('org.kde.plasma.icontasks')[0]
iconmanager.currentConfigGroup = 'General'
iconmanager.writeConfig('launchers', [
    'applications:firefox.desktop',
    'applications:chromium-browser.desktop',
    'applications:mozilla-thunderbird.desktop',
    'applications:discord.desktop',
    'applications:spotify_spotify.desktop',
    'applications:code.desktop',
    'applications:pycharm-community_pycharm-community.desktop',
    'applications:intellij-idea-community_intellij-idea-community.desktop',
    'applications:virt-manager.desktop',
    'applications:virtualbox.desktop',
])
theme = 'breeze-dark'

