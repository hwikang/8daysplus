package com.gtention.the8days;

import android.os.Bundle;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import io.flutter.app.FlutterActivity;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import java.net.URISyntaxException;
import java.nio.ByteBuffer;

public class MainActivity extends FlutterActivity implements PluginRegistrantCallback  {
  private static final String CHANNEL = "8daysplus.payment";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

        
    GeneratedPluginRegistrant.registerWith(this);
    FlutterFirebaseMessagingService.setPluginRegistrant(this);


    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
        new MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, MethodChannel.Result result) {
            switch (call.method) {
           
              case "getAppUrl":
                  try {
                    System.out.println("test");
                    String url = call.argument("url");
                    Log.i("url", url);
                    Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                    result.success(intent.getDataString());
                  } catch (URISyntaxException e) {
                    result.notImplemented();
                  } catch (ActivityNotFoundException e) {
                    result.notImplemented();
                  }
                break;
              case "getMarketUrl": {
                try {
                  String url = call.argument("url");
                  Log.i("url", url);
                  Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                  String scheme = intent.getScheme();
                  System.out.println(scheme);
                  
                    String packageName = intent.getPackage();
                    if (packageName != null) {
                      result.success("market://details?id=" + packageName);
                    }
                  
                  result.notImplemented();
                } catch (URISyntaxException e) {
                  result.notImplemented();
                } catch (ActivityNotFoundException e) {
                  result.notImplemented();
                }
                break;
              }
              
              default:
                break;
            }
         
          }});
    
  }

  private String helloFromNativeCode() {
    return "Hello from Native Android Code";
  }

  @Override
   public void registerWith(PluginRegistry registry) {
     GeneratedPluginRegistrant.registerWith(registry);
   }
  
}


