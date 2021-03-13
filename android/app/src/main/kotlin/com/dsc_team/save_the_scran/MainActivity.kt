package com.dsc_team.save_the_scran

import io.flutter.embedding.android.FlutterActivity
//import sun.rmi.runtime.Log

//import sun.java2d.Surface




class MainActivity: FlutterActivity() {
}

//
//private val ORIENTATIONS: SparseIntArray = SparseIntArray()
//static {
//    ORIENTATIONS.append(Surface.ROTATION_0, 90)
//    ORIENTATIONS.append(Surface.ROTATION_90, 0)
//    ORIENTATIONS.append(Surface.ROTATION_180, 270)
//    ORIENTATIONS.append(Surface.ROTATION_270, 180)
//}
//
///**
// * Get the angle by which an image must be rotated given the device's current
// * orientation.
// */
//@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
//@kotlin.jvm.Throws(CameraAccessException::class)
//private open fun getRotationCompensation(cameraId: String, activity: Activity, context: Context): Int {
//    // Get the device's current rotation relative to its "native" orientation.
//    // Then, from the ORIENTATIONS table, look up the angle the image must be
//    // rotated to compensate for the device's rotation.
//    val deviceRotation: Int = activity.getWindowManager().getDefaultDisplay().getRotation()
//    var rotationCompensation: Int = ORIENTATIONS.get(deviceRotation)
//
//    // On most devices, the sensor orientation is 90 degrees, but for some
//    // devices it is 270 degrees. For devices with a sensor orientation of
//    // 270, rotate the image an additional 180 ((270 + 270) % 360) degrees.
//    val cameraManager: CameraManager = context.getSystemService(CAMERA_SERVICE) as CameraManager
//    val sensorOrientation: Int = cameraManager
//            .getCameraCharacteristics(cameraId)
//            .get(CameraCharacteristics.SENSOR_ORIENTATION)
//    rotationCompensation = (rotationCompensation + sensorOrientation + 270) % 360
//
//    // Return the corresponding FirebaseVisionImageMetadata rotation value.
//    val result: Int
//    when (rotationCompensation) {
//        0 -> result = FirebaseVisionImageMetadata.ROTATION_0
//        90 -> result = FirebaseVisionImageMetadata.ROTATION_90
//        180 -> result = FirebaseVisionImageMetadata.ROTATION_180
//        270 -> result = FirebaseVisionImageMetadata.ROTATION_270
//        else -> {
//            result = FirebaseVisionImageMetadata.ROTATION_0
//            Log.e(TAG, "Bad rotation value: $rotationCompensation")
//        }
//    }
//    return result
//}