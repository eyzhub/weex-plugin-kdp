package org.weex.plugin.weexkdp;

import com.alibaba.weex.plugin.annotation.WeexModule;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import android.util.Log;
import android.widget.Toast;

@WeexModule(name = "weexKdp")
public class WeexKdpModule extends WXModule {

    private static final String TAG = "WeexKdpModule";

    ///sync ret example
    //TODO: Auto-generated method example
    @JSMethod
    public String syncRet(String param) {
        return param;
    }

    //async ret example
    //TODO: Auto-generated method example
    @JSMethod
    public void asyncRet(String param, JSCallback callback) {
        callback.invoke(param);
    }

    @JSMethod (uiThread = true)
    public void show() {
        Log.d(TAG, "Showing!");
        Toast.makeText(mWXSDKInstance.getContext(),"Module weexKdpPlugin is created sucessfully ",Toast.LENGTH_SHORT).show();
    }
}