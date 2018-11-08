package com.react.barcode.utils;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.v4.content.ContextCompat;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.modules.core.PermissionAwareActivity;
import com.facebook.react.modules.core.PermissionListener;


public final class PermissionUtil {
    public static boolean isGranted(Context context, final String... permissions) {
        for (String permission : permissions) {
            if (!isGranted(context, permission)) {
                return false;
            }
        }
        return true;
    }

    private static boolean isGranted(Context context, final String permission) {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M
                || PackageManager.PERMISSION_GRANTED
                == ContextCompat.checkSelfPermission(context, permission);
    }

    public static void requestPermission(ReactContext context, String permission, PermissionCallback callback) {
        new PermissionRequest(context, permission, callback).request();
    }

    private static class PermissionRequest implements PermissionListener {
        private static final int PERMISSIONS_REQUEST_CODE = 1;

        private ReactContext mContext;
        private String mPermission;
        private PermissionCallback mCallback;

        PermissionRequest(ReactContext context, String permission, PermissionCallback callback) {
            mContext = context;
            mPermission = permission;
            mCallback = callback;
        }

        void request() {
            PermissionAwareActivity activity = (PermissionAwareActivity) mContext.getCurrentActivity();
            if (activity != null) {
                activity.requestPermissions(new String[]{mPermission}, PERMISSIONS_REQUEST_CODE, this);
            } else {
                mCallback.invoke(false);
            }
        }

        @Override
        public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
            if (requestCode == PERMISSIONS_REQUEST_CODE &&
                    permissions.length == 1 &&
                    permissions[0].equals(mPermission) &&
                    grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                mCallback.invoke(true);
            } else {
                mCallback.invoke(false);
            }
            return true;
        }
    }

    public static class PermissionCallback {
        public void invoke(boolean isGranted) {

        }
    }
}
