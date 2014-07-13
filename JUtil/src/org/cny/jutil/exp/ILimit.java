package org.cny.jutil.exp;

/**
 * the interface for value limit.
 *
 * @author Centny. 7/11/14.
 */
public interface ILimit {
    /**
     * check the value whether valid or not.
     *
     * @param exp Exp object.
     * @param v   target value.
     * @throws Exception throw exception when check fail.
     */
    void valid(Exp exp, Object v) throws Exception;
}
