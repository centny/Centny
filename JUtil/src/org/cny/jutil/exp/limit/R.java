package org.cny.jutil.exp.limit;

import org.cny.jutil.Ast;
import org.cny.jutil.exp.Exp;
import org.cny.jutil.exp.ILimit;

/**
 * range limit for string or number.
 *
 * @author Centny. 7/11/14.
 */
public class R implements ILimit {
    //the begin value.
    private double beg = 0;
    //the end value.
    private double end = Double.MAX_VALUE;

    @Override
    public void valid(Exp exp, Object v) throws Exception {
        if (v instanceof String) {
            String val = (String) v;
            if (this.beg > val.length() || this.end < val.length()) {
                throw exp.error(String.format("string len invalid %s<len(%s)<%s", this.beg, val.length(), this.end));
            }
        } else if (v instanceof Number) {
            Number val = (Number) v;
            if (this.beg > val.doubleValue() || this.end < val.doubleValue()) {
                throw exp.error(String.format("number value invalid %s<val(%s)<%s", this.beg, val, this.end));
            }
        } else {
            throw exp.error("using R by invalid value type:" + v.getClass());
        }
    }

    /**
     * default constructor by range limit express.
     *
     * @param r the range limit express.
     */
    public R(String r) {
        Ast.yes(r.length(), "range limit is empty or null");
        String[] os = r.split("\\~", 2);
        switch (os.length) {
            case 1:
                this.end = Double.parseDouble(os[0]);
                break;
            default:
                if (!os[0].isEmpty()) {
                    this.beg = Double.parseDouble(os[0]);
                }
                if (!os[1].isEmpty()) {
                    this.end = Double.parseDouble(os[1]);
                }
                break;
        }
    }
}