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
    url: '192.168.65.1'
  };