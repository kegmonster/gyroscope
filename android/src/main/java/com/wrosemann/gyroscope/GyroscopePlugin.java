package com.wrosemann.gyroscope;

import android.app.Application;
import android.content.Context;
import android.hardware.SensorManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;



/** GyroscopePlugin */
public class GyroscopePlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private EventChannel.EventSink eventSink;
  private EventChannel eventChannel;
  private GyroscopeHandler gyroscopeHandler;

  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gyroscope");
    channel.setMethodCallHandler(this);
    registerEventChannel(flutterPluginBinding.getBinaryMessenger());
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("subscribe")) {
      int period = call.argument("rate");
      startGyroscopeListening(eventSink, period * 1000000);
    } else if (call.method.equals("unsubscribe")) {
      stopGyroscopeListening();
    } else {
      result.notImplemented();
    }
  }

  // Method to start listening to gyroscope sensor events
  public void startGyroscopeListening(EventChannel.EventSink eventSink, int period) {
    gyroscopeHandler = new GyroscopeHandler(context);
    gyroscopeHandler.startListening(eventSink, period);
  }

  // Method to stop listening to gyroscope sensor events
  public void stopGyroscopeListening() {
    if (gyroscopeHandler != null) {
      gyroscopeHandler.stopListening();
      gyroscopeHandler = null;
    }
  }

  public void setEventSink(EventChannel.EventSink eventSink) {
    this.eventSink = eventSink;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
  // Method to register the EventChannel

  public void registerEventChannel(BinaryMessenger messenger) {
    eventChannel = new EventChannel(messenger, "gyro_update_channel");
    eventChannel.setStreamHandler(this);
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    setEventSink(events);
  }

  @Override
  public void onCancel(Object arguments) {

  }
}
