package com.rfid.rfid_flutter_android.utils;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;

import com.rscja.CWDeviceInfo;
import com.rscja.team.qcom.DeviceConfiguration_qcom;
import com.rscja.team.qcom.utility.LogUtility_qcom;

import java.lang.reflect.Method;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;


public class DeviceUtil {
    private static final String TAG = "DeviceUtil";

    public static String getImei(Context context, String[] imei2) {
        LogUtility_qcom.myLogV("DeviceUtil", "getImei " + CWDeviceInfo.getDeviceInfo().getModel() + " " + DeviceConfiguration_qcom.getModel());
        if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_QCM2150_100)) {
            return getImeiC60(imei2);
        } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_SMD450_100)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_MTK_6765_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C61P_SM6115_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C66P_SM6115_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C66_SMD450_90)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
                || CWDeviceInfo.getDeviceInfo().getModelAndCpu().equals(CWDeviceInfo.MC51_4350_140)
        ) {
            return getImeiC60_smd450(context, imei2);
        } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            return getImei_mtk(context, imei2);
        } else {
            LogUtility_qcom.myLogV("DeviceUtil", "into else");
            try {
                TelephonyManager manager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
                Class<?> clazz = manager.getClass();
                Method getImei = clazz.getDeclaredMethod("getImei", int.class);//(int slotId)
                //获得IMEI 1的信息：
                Object imei_1 = getImei.invoke(manager, 0);
                //获得IMEI 2的信息：
                Object imei_2 = getImei.invoke(manager, 1);

                if (imei_1 != null && imei_2 != null) {
                    if (imei2 != null && imei2.length > 0) {
                        imei2[0] = imei_2.toString();
                    }
                    return imei_1.toString();
                } else if (imei_1 != null) {
                    return imei_1.toString();
                } else if (imei_2 != null) {
                    return imei_2.toString();
                } else {
                    return null;
                }
            } catch (Exception ignored) {
            }
            return null;
        }
    }


    private static String getImei_mtk(Context context, String[] imei2) {
        String imei1 = Settings.Global.getString(context.getContentResolver(), "Imei1");
        String imei_2 = Settings.Global.getString(context.getContentResolver(), "Imei2");
        if (!TextUtils.isEmpty(imei1)) {
            if (!TextUtils.isEmpty(imei_2)) {
                imei2[0] = imei_2;
            }
        }
        return imei1;
    }

    private static String getImeiC60_smd450(Context context, String[] imei2) {
        String imei1 = Settings.System.getString(context.getContentResolver(), "cw_imei_one");
        String strIMEI2 = Settings.System.getString(context.getContentResolver(), "cw_imei_two");
        if (strIMEI2 != null && imei2 != null && imei2.length > 0) {
            imei2[0] = strIMEI2;
        }
        LogUtility_qcom.myLogV(TAG, "getImeiC60_smd450 imei1=" + imei1 + " imei2=" + (imei2 == null ? "null" : imei2[0]));
        return imei1;
    }

    private static String getImeiC60(String[] imei2) {
        String imei1 = getSystemProperties("persist.quectel.imei1");
        String strIMEI2 = getSystemProperties("persist.quectel.imei2");
        if (strIMEI2 != null && imei2 != null && imei2.length > 0) {
            imei2[0] = strIMEI2;
        }
        return imei1;
    }

    @SuppressLint("PrivateApi")
    public static String getSystemProperties(String properties) {
        String strState = "";
        try {
            Class<?> systemProperties = Class.forName("android.os.SystemProperties");
            Method get = systemProperties.getDeclaredMethod("get", String.class);
            strState = (String) get.invoke(null, properties);
        } catch (Exception e) {
            e.printStackTrace();
        }
        LogUtility_qcom.myLogV("DeviceUtil", "getSystemProperties " + properties + " = " + strState);
        return strState;
    }


    /**
     * 获取设备序列号
     */
    @SuppressLint("HardwareIds")
    public static String getSerialNum(Context context) {
        try {
            if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8953_90)) {
                return getAndroid90Sn();
            } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_QCM2150_100)
                    || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C61P_SM6115_110)
                    || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C66P_SM6115_110)
            ) {
                return getSystemProperties("persist.quectel.sn");
            } else if (CWDeviceInfo.getDeviceInfo().getModelAndCpu().equals(CWDeviceInfo.MC51_4350_140)) {
                return getSystemProperties("persist.sys.quectel.sn");
            } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_SMD450_100)) {
                return getSNC60_smd450(context);
            } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_MTK_6765_110)
                    || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
            ) {
                String sn = getSystemProperties("vendor.gsm.serial");
                sn = sn.substring(0, sn.indexOf(" "));
                LogUtility_qcom.myLogV("SN", "sn=" + sn + " sn.length=" + sn.length());
                return sn;
            } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
                return Settings.Global.getString(context.getContentResolver(), "Serial");
            } else {
                if (Build.VERSION.SDK_INT >= 26) {
                    try {
                        return Build.getSerial();
                    } catch (SecurityException e) {
                        LogUtility_qcom.myLogErr("DeviceUtil", "No READ_PHONE_STATE permission to get serial number");
                        return Build.UNKNOWN;
                    }
                }
                return "";
            }
        } catch (Exception e) {
            LogUtility_qcom.myLogV("DeviceUtil", "getSerialNum error:" + e);
            return "";
        }
    }

    @SuppressLint("PrivateApi")
    public static String getAndroid90Sn() {
        Class<?> systemProperties;
        Method get;
        String strState = "";
        try {
            systemProperties = Class.forName("android.os.SystemProperties");
            get = systemProperties.getDeclaredMethod("get", String.class);
            strState = (String) get.invoke(null, "persist.radio.sn");
        } catch (Exception e) {
            e.printStackTrace();
        }
        LogUtility_qcom.myLogV(TAG, "getAndroid90Sn sn=" + strState);
        return strState;
    }

    private static String getSNC60_smd450(Context context) {
        return Settings.System.getString(context.getContentResolver(), "cw_sn_num");
    }


    public static String getBluetoothAddress(Context context) {
        String btMac = "";
        if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            btMac = Settings.Global.getString(context.getContentResolver(), "BtMac");
            if (!TextUtils.isEmpty(btMac)) {
                LogUtility_qcom.myLogV(TAG, "MTK btMac=" + btMac);
                return btMac;
            }
        } else {
            String data = Settings.System.getString(context.getContentResolver(), "cw_bt_address");
            LogUtility_qcom.myLogV(TAG, "getBluetoothAddress cw_bt_address=" + data);
            if (!TextUtils.isEmpty(data)) {
                return data;
            }
        }

        return "";
    }

    public static boolean isSystemSign(Context context, String packageName) {
        PackageManager packageManager = context.getPackageManager();
        int uid1 = getUid(context, packageName);
        int systemUID = 1000;
        if (packageManager.checkSignatures(uid1, systemUID) == PackageManager.SIGNATURE_MATCH) {
            LogUtility_qcom.myLogV(TAG, "isSystemApplication: true");
            return true;
        }
        LogUtility_qcom.myLogV(TAG, "isSystemApplication: false");
        return false;
    }

    public static int getUid(Context context, String packageName) {
        try {
            PackageManager pm = context.getPackageManager();
            ApplicationInfo ai = pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA);
            //LogUtility_qcom.myLogV(TAG, "ai.uid: " + ai.uid);
            return ai.uid;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return -1;
    }


    @SuppressLint("MissingPermission")
    public static String getWifiMac(Context context) {

        if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C66P_SM6115_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C61P_SM6115_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_MTK_6765_110)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8953_90)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.MC50_4350_120)
                || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
        ) {
            String mac = Settings.System.getString(context.getContentResolver(), "cw_wifi_mac");
            String mac2 = getSharedPreferences(context, "cw_wifi_mac");
            LogUtility_qcom.myLogV(TAG, "getWifiMac mac=" + mac + "  mac2=" + mac2);

            if (TextUtils.isEmpty(mac)) {
                if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8953_90)) {
                    mac = getLocalMacAddress6Above();
                }
            }
            LogUtility_qcom.myLogV(TAG, "Wifi mac=" + mac);
            //校验是否是我们自己写的地址
            if (!TextUtils.isEmpty(mac)) {
                if (mac.toLowerCase().startsWith("cc") || mac.toLowerCase().startsWith("6c:15:24")) {
                    //系统每次开机都会清除   AppConfig.getAppConfig(getApplicationContext()).setSharedPreferences("cw_wifi_mac",mac); 所以，appcenter把这个值记录一下
                    setSharedPreferences(context, "cw_wifi_mac", mac);
                    return mac;
                }
                return mac;
            }
            if (!TextUtils.isEmpty(mac2)) {
                return mac2;
            }
            return "";
        } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            try {
                String wifiMac = Settings.Global.getString(context.getContentResolver(), "WiFiMac");
                if (wifiMac != null && !wifiMac.isEmpty()) {
                    return wifiMac;
                }
                List<NetworkInterface> all = Collections.list(NetworkInterface.getNetworkInterfaces());
                for (NetworkInterface nif : all) {
                    if (!nif.getName().equalsIgnoreCase("wlan0")) continue;

                    byte[] macBytes = nif.getHardwareAddress();
                    if (macBytes == null) {
                        return "";
                    }

                    StringBuilder res1 = new StringBuilder();
                    for (byte b : macBytes) {
                        res1.append(String.format("%02X:", b));
                    }

                    if (res1.length() > 0) {
                        res1.deleteCharAt(res1.length() - 1);
                    }
                    return res1.toString();
                }
            } catch (Exception ignored) {
            }
            return "02:00:00:00:00:00";
        } else {
            return getLocalMacAddress6Above();
        }
    }


    private static String getLocalMacAddress6Above() {
        try {
            List<NetworkInterface> all = Collections.list(NetworkInterface.getNetworkInterfaces());
            for (NetworkInterface nif : all) {
                if (!nif.getName().equalsIgnoreCase("wlan0")) continue;

                byte[] macBytes = nif.getHardwareAddress();
                if (macBytes == null) {
                    return "";
                }
                StringBuilder res1 = new StringBuilder();
                for (byte b : macBytes) {
                    res1.append(String.format("%02X:", b));
                }

                if (res1.length() > 0) {
                    res1.deleteCharAt(res1.length() - 1);
                }
                return res1.toString();
            }
        } catch (Exception ignored) {
        }
        return "02:00:00:00:00:00";
    }

    private static String getSharedPreferences(Context context, String key) {
        return getSP(context).getString(key, "");
    }

    private static SharedPreferences getSP(Context context) {
        return context.getSharedPreferences("config", Context.MODE_PRIVATE);
    }

    private static void setSharedPreferences(Context context, String key, String value) {
        SharedPreferences.Editor editor = getSP(context).edit();
        editor.putString(key, value);
        editor.apply();
    }
}
