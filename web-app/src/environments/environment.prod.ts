export const environment = {
    production: true,

    BACKEND_ROUTES: {
        USER_API: 'api/users',
        LOGIN_API_POST: '/login',
        LOGOUT_API_GET: '/logout',
        REGISTER_API_POST: '/register',
        CURRENT_BOTTLES_POST: '/current-bottles'
    },

    FRONTEND_ROUTES:{
        LOGIN: 'login',
        REGISTER: 'register',
        GESTION: 'gestion',
        ERROR: 'error',
        DASHBOARD: 'dashboard',
        USERS: 'users',
        BOUTEILES: 'bouteille',
        RAPPORTS: 'rapport-sub',
        PROFILE: 'profile'

    },
    server_url: 'http://35.180.117.75:5000'
  };