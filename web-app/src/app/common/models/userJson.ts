export interface Profile {
    name: string;
    surname: string;
    birthday: string;
    gender: string;
    image: string;
  }
  
  export interface Work {
    company: string;
    position: string;
    salary: number;
  }
  
  export interface Contacts {
    email: string;
    phone: string;
    address: string;
  }
  
  export interface Social {
    facebook: string;
    twitter: string;
    google: string;
  }
  
  export interface Settings {
    isActive: boolean;
    isDeleted: boolean;
    registrationDate: string;
    joinedDate: string;
  }
  
  export interface UserJson {
    id: number;
    username: string;
    password: string;
    profile: Profile;
    work: Work;
    contacts: Contacts;
    social: Social;
    settings: Settings;
  }

  export class UserData {
    static data: UserJson[] = [
        {
          "id": 1,
          "username": "pretty",
          "password": "pretty123",
          "profile": {
            "name": "Ashley",
            "surname": "Ahlberg",
            "birthday": "1981-03-28T23:00:00.000Z",
            "gender": "female",
            "image": "img/avatars/avatar-5.png"
          },
          "work": {
            "company": "Google",
            "position": "Marketeur",
            "salary": 5000
          },
          "contacts": {
            "email": "ashley@gmail.com",
            "phone": "(202) 756-9756",
            "address": "Abidjian"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": true,
            "isDeleted": false,
            "registrationDate": "2012-10-13T12:20:40.511Z",
            "joinedDate": "2017-04-21T18:25:43.511Z"
          }
        },
        {
          "id": 2,
          "username": "bruno.V",
          "password": "bruno123",
          "profile": {
            "name": "Bruno",
            "surname": "Vespa",
            "birthday": "1992-12-19T23:00:00.000Z",
            "gender": "male",
            "image": "img/avatars/avatar-1.png"
          },
          "work": {
            "company": "Dell EMC",
            "position": "Client",
            "salary": 17000
          },
          "contacts": {
            "email": "bruno@dell.com",
            "phone": "(415) 231-0332",
            "address": "Abidjian"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": false,
            "isDeleted": false,
            "registrationDate": "2011-01-05T08:45:23.511Z",
            "joinedDate": "2017-05-20T18:25:43.511Z"
          }
        },
        {
          "id": 3,
          "username": "andy.79",
          "password": "andy123",
          "profile": {
            "name": "Andy",
            "surname": "Warhol",
            "birthday": "1979-11-20T23:00:00.000Z",
            "gender": "male",
            "image": "img/avatars/avatar-3.png"
          },
          "work": {
            "company": "Adecco",
            "position": "Emplisseur",
            "salary": 13000
          },
          "contacts": {
            "email": "andy@adecco.com",
            "phone": "(212) 457-2308",
            "address": "Abidjian"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": true,
            "isDeleted": false,
            "registrationDate": "2014-11-01T19:35:43.511Z",
            "joinedDate": "2017-06-28T15:25:43.511Z"
          }
        },
        {
          "id": 4,
          "username": "julia.a",
          "password": "julia123",
          "profile": {
            "name": "Julia",
            "surname": "Aniston",
            "birthday": "1982-07-17T22:00:00.000Z",
            "gender": "female",
            "image": "img/avatars/avatar-4.png"
          },
          "work": {
            "company": "Apple",
            "position": "Revendeurr",
            "salary": 18000
          },
          "contacts": {
            "email": "julia@apple.com",
            "phone": "(224) 267-1346",
            "address": "Marcory"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": true,
            "isDeleted": false,
            "registrationDate": "2015-12-06T11:10:20.511Z",
            "joinedDate": "2017-06-29T15:15:40.511Z"
          }
        },
        {
          "id": 5,
          "username": "lusia.m",
          "password": "lusia123",
          "profile": {
            "name": "Lusia",
            "surname": "Manuel",
            "birthday": "1993-01-01T23:00:00.000Z",
            "gender": "female",
            "image": "img/avatars/avatar-7.png"
          },
          "work": {
            "company": "Alphabet",
            "position": "Marketeur",
            "salary": 10000
          },
          "contacts": {
            "email": "lusia@alphabet.com",
            "phone": "(224) 267-1346",
            "address": "Yopougon"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": true,
            "isDeleted": true,
            "registrationDate": "2014-01-10T10:20:20.511Z",
            "joinedDate": "2017-06-28T12:20:40.511Z"
          }
        },
        {
          "id": 6,
          "username": "adam.82",
          "password": "adam123",
          "profile": {
            "name": "Adam",
            "surname": "Sandler",
            "birthday": "1988-01-23T23:00:00.000Z",
            "gender": "male",
            "image": "img/avatars/avatar-6.png"
          },
          "work": {
            "company": "General Electric",
            "position": "Transporteur",
            "salary": 21000
          },
          "contacts": {
            "email": "adam@gen-el.com",
            "phone": "(224) 267-1346",
            "address": "Treichville"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": false,
            "isDeleted": false,
            "registrationDate": "2016-11-16T12:20:20.511Z",
            "joinedDate": "2017-06-27T14:20:40.511Z"
          }
        },
        {
          "id": 7,
          "username": "tereza.s",
          "password": "tereza123",
          "profile": {
            "name": "Tereza",
            "surname": "Stiles",
            "birthday": "1979-08-08T22:00:00.000Z",
            "gender": "female",
            "image": "img/avatars/avatar-2.png"
          },
          "work": {
            "company": "Client",
            "position": "Sale manager",
            "salary": 31000
          },
          "contacts": {
            "email": "tereza@airlines.com",
            "phone": "(214) 617-2614",
            "address": "Cocody"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": true,
            "isDeleted": false,
            "registrationDate": "2010-10-12T16:20:20.511Z",
            "joinedDate": "2017-06-29T15:20:40.511Z"
          }
        },
        {
          "id": 8,
          "username": "michael.b",
          "password": "michael123",
          "profile": {
            "name": "Michael",
            "surname": "Blair",
            "birthday": "1978-12-14T23:00:00.000Z",
            "gender": "male",
            "image": "img/avatars/avatar-8.png"
          },
          "work": {
            "company": "Microsoft",
            "position": "Transporteur",
            "salary": 50000
          },
          "contacts": {
            "email": "michael@microsoft.com",
            "phone": "(267) 388-1637",
            "address": "Abidjian"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": true,
            "isDeleted": false,
            "registrationDate": "2009-08-12T16:20:20.511Z",
            "joinedDate": "2017-06-29T16:25:43.511Z"
          }
        },
        {
          "id": 9,
          "username": "sebastian.m",
          "password": "sebastian123",
          "profile": {
            "name": "Sebastian",
            "surname": "Martinez",
            "birthday": "1985-06-05T23:00:00.000Z",
            "gender": "male",
            "image": "img/avatars/avatar-9.png"
          },
          "work": {
            "company": "Amazon",
            "position": "Emplisseur",
            "salary": 25000
          },
          "contacts": {
            "email": "sebastian@amazon.com",
            "phone": "(312) 563-4801",
            "address": "Yopougon"
          },
          "social": {
            "facebook": "",
            "twitter": "",
            "google": ""
          },
          "settings": {
            "isActive": true,
            "isDeleted": false,
            "registrationDate": "2012-02-14T11:10:20.511Z",
            "joinedDate": "2017-06-28T13:25:43.511Z"
          }
        }
      ];
  }