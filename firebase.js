const { initializeApp } =require("firebase/app") ;
const {getFirestore}=require('firebase/firestore');
const firebaseConfig = {
  apiKey: "AIzaSyD7Gg9SEvfMrCMaAgxtAHeHWp6QZj3VK9Q",
  authDomain: "mev-bot-42230.firebaseapp.com",
  projectId: "mev-bot-42230",
  storageBucket: "mev-bot-42230.appspot.com",
  messagingSenderId: "455140240585",
  appId: "1:455140240585:web:a400171325bdfd02177118",
  measurementId: "G-071WZ327R6"
};

const app = initializeApp(firebaseConfig);
 const db = getFirestore();

module.exports={db}