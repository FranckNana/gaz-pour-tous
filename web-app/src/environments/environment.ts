export const environment = {

    production: false,

    BACKEND_ROUTES: {
        USER_API: 'api/users',
        LOGIN_API_POST: '/login',
        LOGOUT_API_GET: '/logout',
        REGISTER_API_POST: '/register'
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

    server_url: 'http://localhost:5000'
}