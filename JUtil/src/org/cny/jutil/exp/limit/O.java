package org.cny.jutil.exp.limit;

import org.cny.jutil.exp.Exp;
import org.cny.jutil.exp.ILimit;

import java.util.HashSet;
import java.util.Set;

/**
 * option limit for string or number.
 *
 * @author Centny. 7/11/14.
 */
public class O implements ILimit {
    //the option set.
    private Set<Object> os = new HashSet<Object>();

    @Override
    public void valid(Exp exp, Object v) throws Exception {
        if (!this.os.contains(v)) {
            throw exp.error(String.format("value(%s) is not in (%s)", v, this.os));
        }
    }

    /**
     * default constructor by option limit express and value type.
     *
     * @param o     the option limit express.
     * @param vtype the value type.
     */
    public O(String o, Exp.ValType vtype) {
        String[] oset = o.split("\\~");
        switch (vtype) {
            case I:
                for (String ov : oset) {
                    this.os.add(Long.parseLong(ov));
                }
                break;
            case F:
                for (String ov : oset) {
                    this.os.add(Double.parseDouble(ov));
                }
                break;
            case S:
                for (String ov : oset) {
                    this.os.add(ov);
                }
                break;
        }
    }
}
