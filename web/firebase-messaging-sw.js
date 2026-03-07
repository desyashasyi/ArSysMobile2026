importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCM5hmKk10BvddjoxzwkVqt00DqtNExxZA',
  appId: '1:475080104398:android:e2c6777ccfbcc7797c739f',
  messagingSenderId: '475080104398',
  projectId: 'arsysmobile',
  storageBucket: 'arsysmobile.firebasestorage.app',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
