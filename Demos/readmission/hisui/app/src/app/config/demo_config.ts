export default {
  CREDENTIALS:{
    userName: "SuperUser",
    password: "sys"
  },
  URL:{
    userList: 'http://localhost:9096/csp/appint/rest/encounter/list',
    dischargeUser: 'http://localhost:9096/csp/appint/rest/encounter/discharge/',
    resetDemo: 'http://localhost:9096/csp/appint/rest/encounter/resetdemo/',

    workflow:{
      root: 'http://localhost:9092/csp/appint/rest/workflow/',
      tasks: 'tasks',
      clear: 'tasks/clear',
      task: 'task',
      assign: 'task/assign',
      unassign: 'task/unassign',
      complete: 'task/complete'
    }
  }
}
