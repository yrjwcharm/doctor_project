package com.sinosoft.doctor_project

import android.app.Application
import android.content.Context
import androidx.multidex.MultiDex
import com.sinosoft.myapplication.CrashHandler
import com.tencent.bugly.crashreport.CrashReport

class MyApplication : Application() {

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this);
        CrashHandler.instance?.init(this);
        CrashReport.initCrashReport(applicationContext, "5184f48c51", false)
    }
}