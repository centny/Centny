package org.cny.jutil;

import org.cny.jutil.exception.AssertFailException;

import java.util.Collection;
import java.util.Map;

/**
 * @author Centny. 7/11/14.
 */
public class Ast {
    public static void yes(Object t, String format, Object... args) throws AssertFailException {
        if (!yes(t)) {
            throw new AssertFailException(String.format(format, args));
        }
    }

    public static void no(Object t, String format, Object... args) throws AssertFailException {
        if (yes(t)) {
            throw new AssertFailException(String.format(format, args));
        }
    }

    public static boolean yes(Object t) {
        if (t == null) {
            return false;
        }
        if (t instanceof Boolean) {
            return (Boolean) t;
        }
        if (t instanceof Long) {
            return (Long) t > 0L;
        }
        if (t instanceof Integer) {
            return (Integer) t > 0;
        }
        if (t instanceof Double) {
            return (Double) t > 0D;
        }
        if (t instanceof Float) {
            return (Float) t > 0F;
        }
        if (t instanceof Byte) {
            return (Byte) t > 0;
        }
        if (t instanceof Short) {
            return (Short) t > 0;
        }
        if (t instanceof String) {
            return ((String) t).trim().length() > 0;
        }
        if (t instanceof Collection) {
            return ((Collection<?>) t).size() > 0;
        }
        if (t instanceof Map) {
            return ((Map<?, ?>) t).size() > 0;
        }
        return false;
    }

}
