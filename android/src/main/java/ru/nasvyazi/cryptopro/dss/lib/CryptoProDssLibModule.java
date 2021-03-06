package ru.nasvyazi.cryptopro.dss.lib;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.FragmentActivity;

import com.digt.sdk.*;
import com.digt.sdk.auth.Auth;
import com.digt.sdk.auth.models.DssUser;
import com.digt.sdk.auth.models.RawQR;
import com.digt.sdk.auth.models.RegisterInfo;
import com.digt.sdk.cert.Cert;
import com.digt.sdk.cert.models.Certificate;
import com.digt.sdk.docs.Docs;
import com.digt.sdk.interfaces.SdkCallback;
import com.digt.sdk.interfaces.SdkCertificateListCallback;
import com.digt.sdk.interfaces.SdkDssUserCallback;
import com.digt.sdk.interfaces.SdkGetDocumentCallback;
import com.digt.sdk.interfaces.SdkInitCallback;
import com.digt.sdk.interfaces.SdkMtOperationCallback;
import com.digt.sdk.interfaces.SdkMtOperationWithSuspendCallback;
import com.digt.sdk.interfaces.SdkPolicyCaParamsCallback;
import com.digt.sdk.interfaces.SdkPolicyDevicesCallback;
import com.digt.sdk.interfaces.SdkPolicyOperationHistoryCallback;
import com.digt.sdk.interfaces.SdkPolicyOperationsInfoCallback;
import com.digt.sdk.interfaces.SdkQrCallback;
import com.digt.sdk.policy.Policy;
import com.digt.sdk.policy.models.CaParams;
import com.digt.sdk.policy.models.DeviceInfo;
import com.digt.sdk.policy.models.OperationHistory;
import com.digt.sdk.sign.Sign;
import com.digt.sdk.sign.models.ApproveRequestMT;
import com.digt.sdk.sign.models.Operation;
import com.digt.sdk.sign.models.OperationsInfo;
import com.digt.sdk.utils.Constants;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMarker;
import com.facebook.react.bridge.ReactMarkerConstants;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.common.LifecycleState;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.ref.WeakReference;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static android.os.Looper.getMainLooper;
import static ru.nasvyazi.cryptopro.dss.lib.ReactBridgeTools.convertJsonToMap;

class InitCallbackHandler implements SdkInitCallback {
    public void onInit(Constants.CSPInitCode var1) {
        System.out.println(var1);
    }
}

public class CryptoProDssLibModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private Auth lastAuth;


    @SuppressLint("RestrictedApi")
    public CryptoProDssLibModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }



    @Override
    public String getName() {
        return "CryptoProDssLib";
    }



    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void onResumeActivity() {
        //CryptoProDss.registerActivityContext(getReactApplicationContext());
     }

     public void reject(Promise promise, String text) {
         promise.reject("CryptoProDssLib", text);
     }


    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void sdkInitialization(Promise promise) {

        new Handler(getMainLooper()).post(new Runnable() {
            @Override
            public void run() {

                CryptoProDss.initDSS(((FragmentActivity)getReactApplicationContext().getCurrentActivity()));
                CryptoProDss.getInstance().init(((FragmentActivity)getReactApplicationContext().getCurrentActivity()),new HashMap<String,String[]>(),new InitCallbackHandler(){
                    @Override
                    public void onInit(Constants.CSPInitCode var1) {

                        promise.resolve(var1.getTitle());
                    }
                });
            }
        });


    }

    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void switchHeader(Boolean state, Promise promise) {

        new Handler(getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                promise.resolve(null);
            }
        });


    }

    public URI getUriFromAssets(String pathResource) throws IOException {
        InputStream inputStream = null;
        OutputStream outputStream = null;

        inputStream = getReactApplicationContext().getAssets().open(pathResource);
        File tempFile = File.createTempFile("tmp", ".bin");
        byte[] fileReader = new byte[4096];
        outputStream = new FileOutputStream(tempFile);

        while (true){
            int read = inputStream.read(fileReader);
            if (read == -1){
                break;
            }
            outputStream.write(fileReader, 0, read);
        }
        outputStream.flush();
        return tempFile.toURI();
    }

    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void updateStyles(Promise promise) throws URISyntaxException {
        Policy policy = new Policy();

        URI url = null;
        try {
            url = getUriFromAssets("SDKStyles.json");
            policy.setPersonalisation(url);
           promise.resolve("updateStyles success");
        } catch (IOException e) {
            reject(promise, "cant load styles (updateStyles)");
        }
    }





    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void getOperations(String kid,Promise promise) {
        Policy policy = new Policy();
        policy.getOperations(getReactApplicationContext().getCurrentActivity(), kid, null, null, new SdkPolicyOperationsInfoCallback() {
            @Override
            public void onOperationSuccessful(@NonNull OperationsInfo operationsInfo) {
                List<WritableMap> listWithJson =  new ArrayList<>();
                for (Operation operation : operationsInfo.getOperations())
                {
                    try {
                        listWithJson.add(convertJsonToMap(new JSONObject(operation.toJsonString())));
                    } catch (JSONException e) {
                        reject(promise, String.format("json error (getOperations)"));
                    }
                }
                WritableNativeArray array = Arguments.makeNativeArray((List)listWithJson);
                promise.resolve(array);
            }

            @Override
            public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {
                reject(promise, String.format("%s (getOperations)", s));
            }
        });
    }


    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void signMT(String transactionId, String kid, Promise promise) {
        Sign sign = new Sign();

        Policy policy = new Policy();
        policy.getOperations(getReactApplicationContext().getCurrentActivity(), kid, null, null, new SdkPolicyOperationsInfoCallback() {
            @Override
            public void onOperationSuccessful(@NonNull OperationsInfo operationsInfo) {

                Operation _operation = null;

                for (Operation operation : operationsInfo.getOperations())
                {
                    if (operation.getTransactionId().equals(transactionId)){
                        _operation = operation;
                    }
                }


                Operation final_operation = _operation;
                sign.signMT(getReactApplicationContext().getCurrentActivity(),kid,_operation, false,false,false, new SdkMtOperationWithSuspendCallback() {
                    @Override
                    public void onOperationSuccessful() {
                        promise.resolve("success");
                    }

                    @Override
                    public void onOperationSuspendedConfirm(@NonNull ApproveRequestMT approveRequestMT) {


                        sign.deferredRequest(getReactApplicationContext().getCurrentActivity(), kid, approveRequestMT, new SdkMtOperationCallback() {
                            @Override
                            public void onOperationSuccessful() {
                                try {
                                    promise.resolve(convertJsonToMap(new JSONObject(approveRequestMT.toJsonString())));
                                } catch (JSONException e) {
                                    reject(promise, String.format("JSON ERROR (deferredRequest)"));
                                }
                            }

                            @Override
                            public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {
                                reject(promise, String.format("%s (deferredRequest)", s));
                            }
                        });
                    }

                    @Override
                    public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {
                        reject(promise, String.format("%s (signMT)", s));
                    }
                });
            }

            @Override
            public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {
                reject(promise, String.format("%s (getoperations.signMT)", s));
            }
        });

    }




    private String getLastUserKid(){
        List<DssUser> authList = new ArrayList<DssUser>();
        try {
            authList = Auth.getAuthList(getReactApplicationContext().getCurrentActivity());
        } catch (Exception e) {
            Log.i("nasvyzi", e.toString());
            e.printStackTrace();
        }

        DssUser lastUser = authList.get(authList.size()-1);

        return lastUser.getKid();
    }

    public Map<String, String> convertDssUser(DssUser user){
        Map<String, String> object = new HashMap<>();
        object.put("kid", user.getKid());
        object.put("uid", user.getUid());
        return object;
    }

    public Map<String, String> convertDeviceInfo(DeviceInfo info){
        Map<String, String> object = new HashMap<>();
        object.put("kid", info.getKid());
        object.put("uid", info.getUid());
        object.put("deviceName", info.getDeviceName());
        object.put("profile", info.getProfile());
        return object;
    }

    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void getUsers(Promise promise) {
        List<DssUser> authList = new ArrayList<DssUser>();
        try {

            authList = Auth.getAuthList(getReactApplicationContext().getCurrentActivity());
        } catch (Exception e) {
            Log.i("nasvyzi", e.toString());
            e.printStackTrace();
        }

        List<Map<String, String>> list = new ArrayList<>();

        authList.forEach(dssUser -> {
            list.add(convertDssUser(dssUser));
        });

        WritableNativeArray array = Arguments.makeNativeArray((List)list);
        promise.resolve(array);
    }

    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void getUserDevices(String kid, Promise promise) {
        List<DssUser> authList = new ArrayList<DssUser>();
        Policy policy = new Policy();
        try {
            policy.getUserDevices(getReactApplicationContext().getCurrentActivity(), kid, new SdkPolicyDevicesCallback() {
                @Override
                public void onOperationSuccessful(@NonNull List<DeviceInfo> list) {
                    List<Map<String, String>> resultList = new ArrayList<>();

                    list.forEach(info -> {
                        resultList.add(convertDeviceInfo(info));
                    });

                    WritableNativeArray array = Arguments.makeNativeArray((List)resultList);
                    promise.resolve(array);
                }

                @Override
                public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {
                    reject(promise, String.format("%s (getUserDevices)", s));
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
            reject(promise, String.format("%s (unknown.getUserDevices)", e.toString()));
        }
    }

    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void continueInitViaQr(String kid,Promise promise) {
        lastAuth.confirm(getReactApplicationContext().getCurrentActivity(), kid, new SdkCallback() {
            @Override
            public void onOperationSuccessful() {
                lastAuth.verify(getReactApplicationContext().getCurrentActivity(), kid, false, new SdkCallback() {
                    @Override
                    public void onOperationSuccessful() {
                        promise.resolve("success");
                    }

                    @Override
                    public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {

                        reject(promise, String.format("%s (auth.verify)", s));
                    }
                });
            }

            @Override
            public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {
                reject(promise, String.format("%s (auth.confirm)", s));
            }
        });
    }

    @SuppressLint("RestrictedApi")
    @ReactMethod
    public void initViaQr(String base64, Boolean useBiometric, Promise promise) {

        DssUser dssUser = new DssUser();
        RegisterInfo registerInfo = new RegisterInfo(null, null);
        lastAuth = new Auth();
        lastAuth.scanQr(this.reactContext.getCurrentActivity(), base64, new SdkQrCallback() {

            @Override
            public void onOperationSuccessful(@NonNull RawQR rawQR) {
                lastAuth.kinit(getReactApplicationContext().getCurrentActivity(), dssUser, registerInfo, useBiometric ? Constants.KeyProtectionType.BIOMETRIC : Constants.KeyProtectionType.PASSWORD, null, null, new SdkDssUserCallback() {

                    @Override
                    public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {
                        reject(promise, String.format("%s (kinit)", s));
                    }

                    @Override
                    public void onOperationSuccessful(String s) {
                        promise.resolve("success");
                    }
                });
            }

            @Override
            public void onOperationFailed(int i, @Nullable String s, @Nullable Throwable throwable) {
                reject(promise, String.format("%s (scanQr)", s));
            }

            @Override
            public void onOperationCancelled() {

                promise.resolve("cancel");
            }
        });
    }

}
