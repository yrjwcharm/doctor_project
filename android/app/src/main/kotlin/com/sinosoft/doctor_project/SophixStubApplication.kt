package com.sinosoft.doctor_project

import android.content.Context
import android.util.Log
import androidx.annotation.Keep
import androidx.multidex.MultiDex
import com.sinosoft.myapplication.CrashHandler
import com.taobao.sophix.PatchStatus
import com.taobao.sophix.SophixApplication
import com.taobao.sophix.SophixEntry
import com.taobao.sophix.SophixManager
import com.taobao.sophix.listener.PatchLoadStatusListener
import com.tencent.bugly.crashreport.CrashReport
import java.lang.Exception

/**
 * Sophix入口类，专门用于初始化Sophix，不应包含任何业务逻辑。
 * 此类必须继承自SophixApplication，onCreate方法不需要实现。
 * 此类不应与项目中的其他类有任何互相调用的逻辑，必须完全做到隔离。
 * AndroidManifest中设置application为此类，而SophixEntry中设为原先Application类。
 * 注意原先Application里不需要再重复初始化Sophix，并且需要避免混淆原先Application类。
 * 如有其它自定义改造，请咨询官方后妥善处理。
 */
class SophixStubApplication : SophixApplication() {
    private val TAG = "SophixStubApplication"

    // 此处SophixEntry应指定真正的Application，并且保证RealApplicationStub类名不被混淆。
    @Keep
    @SophixEntry(MyApplication::class)
    internal class RealApplicationStub

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        //         如果需要使用MultiDex，需要在此处调用。
        MultiDex.install(this);
        initSophix()
    }

    override fun onCreate() {
        super.onCreate()
        //热修复
        SophixManager.getInstance().queryAndLoadNewPatch()
    }

    private fun initSophix() {
        var appVersion: String? = "1.0.0"
        try {
            appVersion = this.packageManager
                .getPackageInfo(this.packageName, 0).versionName
        } catch (e: Exception) {
        }
        val instance = SophixManager.getInstance()
        instance.setContext(this)
            .setAppVersion(appVersion)
            .setEnableDebug(true)
            .setAesKey(null)
            .setEnableFullLog()
//            .setSecretMetaData("你的 id", "你的 key", "RSA密钥")
            .setPatchLoadStatusStub { mode, code, info, handlePatchVersion ->
                Log.e(
                    TAG,
                    "sophix load patch! mode:$mode code:$code info:$info handlePatchVersion:$handlePatchVersion"
                )
                if (code == PatchStatus.CODE_LOAD_SUCCESS) {
                    Log.i(TAG, "sophix load patch success!")
                } else if (code == PatchStatus.CODE_LOAD_RELAUNCH) {
                    // 如果需要在后台重启，建议此处用SharePreference保存状态。
                    Log.i(TAG, "sophix preload patch success. restart app to make effect.")
                }
            }.initialize()
//        instance.setContext(this)
//            .setAppVersion(appVersion)
//            .setAesKey(null)
//            .setEnableDebug(true)
//            .setEnableFullLog()
//            .setPatchLoadStatusStub(PatchLoadStatusListener(){
//
//            }).initialize()
    }

    companion object {
        /**用来判断是否要使用冷启动（重启App）的方式使补丁生效 */
        var isRelaunch = false
    }
}
