package com.sinosoft.doctor_project

import android.Manifest
import android.app.AlertDialog
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import com.taobao.sophix.SophixManager


class MainActivity : FlutterActivity() {

    private val REQUEST_EXTERNAL_STORAGE_PERMISSION = 0
    private val TAG = this.javaClass.simpleName
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        setContentView(R.layout.activity_main)
//        initPermissions()
    }

//    override fun onDestroy() {
//        super.onDestroy()
//        if (SophixStubApplication.isRelaunch) {
//            Log.i(TAG, "如果是冷启动，则杀死App进程，从而加载补丁:")
//            SophixStubApplication.isRelaunch = false
//            SophixManager.getInstance().killProcessSafely()
//        }
//    }
//
//    /**
//     * 配置Android 6.0 以上额外的权限
//     */
//    private fun initPermissions() {
//        //配置微信登录和6.0权限
//        if (Build.VERSION.SDK_INT >= 23) {
//            val mPermissionList = arrayOf<String>(
//                Manifest.permission.READ_EXTERNAL_STORAGE,  //读取储存权限
//                Manifest.permission.WRITE_EXTERNAL_STORAGE
//            )
//            if (checkPermissionAllGranted(mPermissionList)) {
//                /*查询是否有新补丁需要载入*/
//                SophixManager.getInstance().queryAndLoadNewPatch()
//            } else {
//                ActivityCompat.requestPermissions(
//                    this,
//                    mPermissionList,
//                    REQUEST_EXTERNAL_STORAGE_PERMISSION
//                )
//            }
//        } else {
//            /*查询是否有新补丁需要载入*/
//            SophixManager.getInstance().queryAndLoadNewPatch()
//        }
//    }
//    /**
//     * 检查是否拥有指定的所有权限
//     */
//    private fun checkPermissionAllGranted(permissions: Array<String>): Boolean {
//        for (permission in permissions) {
//            if (ContextCompat.checkSelfPermission(
//                    this,
//                    permission
//                ) != PackageManager.PERMISSION_GRANTED
//            ) {
//                // 只要有一个权限没有被授予, 则直接返回 false
//                return false
//            }
//        }
//        return true
//    }
//
//    override fun onRequestPermissionsResult(
//        requestCode: Int,
//        permissions: Array<out String>,
//        grantResults: IntArray
//    ) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
//        when (requestCode) {
//            REQUEST_EXTERNAL_STORAGE_PERMISSION -> if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//                Log.i(TAG, "成功获得权限")
//                /*查询是否有新补丁需要载入*/SophixManager.getInstance().queryAndLoadNewPatch()
//            } else {
//                AlertDialog.Builder(this)
//                    .setMessage("未获得权限，无法获得补丁升级功能")
//                    .setPositiveButton("设置", object : DialogInterface.OnClickListener {
//                        override fun onClick(p0: DialogInterface?, p1: Int) {
//                            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
//                            intent.setData(Uri.parse("package:$packageName"))
//                            startActivity(intent)
//                        }
//                    }).setNegativeButton("取消", null).show()
//            }
//            else -> {
//            }
//        }
//    }

}
