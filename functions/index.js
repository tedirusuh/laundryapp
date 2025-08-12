// functions/index.js

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

/**
 * Trigger ini berjalan OTOMATIS setiap kali ada pengguna baru dibuat.
 * Fungsinya untuk membuat dokumen profil di koleksi 'users'.
 */
exports.createUserDocument = functions.auth.user().onCreate(async (user) => {
  const {email, uid, photoURL, displayName} = user;

  const newUserProfile = {
    email: email,
    fullName: displayName || "Pengguna Baru",
    photoUrl: photoURL || "",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  try {
    await db.collection("users").doc(uid).set(newUserProfile);
    console.log(`Profil untuk UID: ${uid} berhasil dibuat.`);
  } catch (error) {
    console.error("Gagal membuat profil pengguna:", error);
  }
});
