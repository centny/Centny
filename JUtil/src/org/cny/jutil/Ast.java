package org.cny.jutil;

import org.cny.jutil.exception.AssertFailException;

import java.util.Collection;
import java.util.Map;

/**
 * class for Assert value.
 *
 * @author Centny. 7/11/14.
 */
public class Ast {
    /**
     * assert true to value,throw the error when assert fail.
     *
     * @param t      target value.
     * @param format string format.
     * @param args   format arguments.
     * @throws AssertFailException assert fail exception.
     */
    public static void yes(Object t, String format, Object... args) throws AssertFailException {
        if (!yes(t)) {
            throw new AssertFailException(String.format(format, args));
        }
    }

    /**
     * assert false to value,throw the error when assert fail.
     *
     * @param t      target value.
     * @param format string format.
     * @param args   format arguments.
     * @throws AssertFailException assert fail exception.
     */
    public static void no(Object t, String format, Object... args) throws AssertFailException {
        if (yes(t)) {
            throw new AssertFailException(String.format(format, args));
        }
    }

    /**
     * check value if true.<br/>
     * if object is boolean, return directory.<br/>
     * if object is number/short/byte,check greater zero.<br/>
     * if object is string,check is empty or null.<br/>
     * if object is collection/map,check size.
     *
     * @param t target value.
     * @return true/false.
     */
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
