package com.wrosemann.gyroscope;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import io.flutter.plugin.common.EventChannel;

public class GyroscopeHandler implements SensorEventListener{
    private SensorManager sensorManager;
    private Sensor gyroscopeSensor;
    private EventChannel.EventSink eventSink;


    public GyroscopeHandler(Context context){
        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        gyroscopeSensor = sensorManager.getDefaultSensor(Sensor.TYPE_GAME_ROTATION_VECTOR);
    }

    public void startListening(EventChannel.EventSink eventSink, int period) {
        this.eventSink = eventSink;
        sensorManager.registerListener(this, gyroscopeSensor, period);
    }

    public void stopListening() {
        sensorManager.unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        float[] rotationVector = event.values;

        // Convert rotation vector to rotation matrix
        float[] rotationMatrix = new float[9];
        float[] inMatrix = new float[9];
        SensorManager.getRotationMatrixFromVector(rotationMatrix, rotationVector);

        SensorManager.remapCoordinateSystem(rotationMatrix, SensorManager.AXIS_Z, SensorManager.AXIS_MINUS_X, inMatrix);
        // Convert rotation matrix to Euler angles
        float[] orientation = new float[3];
        SensorManager.getOrientation(inMatrix, orientation);

        float roll = orientation[0];
        float pitch = orientation[1];
        float yaw = orientation[2];


        eventSink.success(new float[]{ -1*pitch, -1*roll, -1*yaw});
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}
