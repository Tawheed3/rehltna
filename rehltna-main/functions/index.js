/**
 * Import function triggers from their respective submodules
 */

const {onRequest} = require("firebase-functions/v2/https");

const {onDocumentCreated} = require("firebase-functions/v2/firestore");

const logger = require("firebase-functions/logger");

// The Firebase Admin SDK to access Firestore and Messaging.
const {initializeApp} = require("firebase-admin/app");

const {getMessaging} = require("firebase-admin/messaging");

initializeApp();

// دالة HTTP للاختبار (اختياري)
exports.helloWorld = onRequest((request, response) => {

  logger.info("Hello logs!", {structuredData: true});

  response.send("Hello from Firebase!");

});

// الدالة الرئيسية: ترسل إشعار عند إنشاء منشور جديد
exports.sendNewPostNotification = onDocumentCreated("/posts/{postId}", async (event) => {

  // الحصول على بيانات المنشور الجديد

  const snapshot = event.data;

  if (!snapshot) {

    logger.log("No data associated with the event");

    return;

  }

  const post = snapshot.data();

  const postId = event.params.postId;

  // استخراج عنوان الرحلة للإشعار

  const tripName = post?.tripName || 'رحلة جديدة';

  const title = '📢 رحلة جديدة!';

  const body = `تم إضافة رحلة جديدة: ${tripName}`;

  logger.log(`New post created: ${postId} - ${tripName}`);

  // إعداد payload الإشعار
  const message = {

    notification: {

      title: title,

      body: body,

    },

    data: {

      postId: postId,

      subCategoryId: post?.subCategoryId || '',

      click_action: 'FLUTTER_NOTIFICATION_CLICK',

    },

    topic: 'all',

  };

  // إرسال الإشعار
  try {

    await getMessaging().send(message);

    logger.log("✅ Notification sent successfully for post:", postId);

    return null;

  } catch (error) {

    logger.error("❌ Error sending notification:", error);

    return null;

  }

});
