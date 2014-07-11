package org.cny.jutil.exception;

/**
 * Created by cny on 7/11/14.
 */
public class AssertFailException extends RuntimeException {
    public AssertFailException(String message) {
        super(message);
    }

    public AssertFailException(String message, Throwable cause) {
        super(message, cause);
    }
}
