package com.sinosoft.myapplication

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.os.Process
import android.widget.Toast

class CrashHandler private constructor() : Thread.UncaughtExceptionHandler {
    private var mDefaultUncaughtExceptionHandler: Thread.UncaughtExceptionHandler? = null
    private var mContext: Context? = null
    override fun uncaughtException(thread: Thread, throwable: Throwable) {
        Thread {
            Looper.prepare()
            Toast.makeText(
                mContext,
                "程序发生崩溃，正在尝试重启",
                Toast.LENGTH_SHORT
            ).show()
            Looper.loop()
        }.start()
        try {
            Thread.sleep(1000)
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }
        //        SystemClock.sleep(2000);
        val intent = mContext!!.packageManager.getLaunchIntentForPackage(
            mContext!!.packageName
        )
        intent!!.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        mContext!!.startActivity(intent)
        Process.killProcess(Process.myPid())


//        Intent intent = new Intent(mContext, MainActivity.class);
//        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        mContext.startActivity(intent);
//        android.os.Process.killProcess(android.os.Process.myPid());

//        final PendingIntent pendingIntent = PendingIntent.getActivity(
//                mContext, 0, new Intent(mContext, MainActivity.class), PendingIntent.FLAG_ONE_SHOT);
//        Log.d(mContext.getPackageName(), "Exception not handled, relaunching", throwable);
//        final AlarmManager alarmManager = (AlarmManager)mContext. getSystemService(Context.ALARM_SERVICE);
//        alarmManager.set(AlarmManager.RTC, System.currentTimeMillis(), pendingIntent);
//        System.exit(0);
        mDefaultUncaughtExceptionHandler!!.uncaughtException(thread, throwable)
    }

    fun init(context: Context?) {
        /*
         * 弹出解决方案之后把崩溃继续交给系统处理，
         * 所以保存当前UncaughtExceptionHandler用于崩溃发生时使用。
         */
        requireNotNull(context) { "Context is null!!!" }
        mContext = context.applicationContext
        mDefaultUncaughtExceptionHandler = Thread.getDefaultUncaughtExceptionHandler()
        Thread.setDefaultUncaughtExceptionHandler(this)
    }

    companion object {
        //同步锁在此处
        //使用双重检查,好处在于后面线程不需要进入线程同步，直接判断instance提升效率
        @SuppressLint("StaticFieldLeak")
        var instance: CrashHandler? = null
            get() {
                if (field == null) {  //使用双重检查,好处在于后面线程不需要进入线程同步，直接判断instance提升效率
                    synchronized(CrashHandler::class.java) {  //同步锁在此处
                        if (field == null) {
                            field = CrashHandler()
                        }
                    }
                }
                return field
            }
            private set
    }
}