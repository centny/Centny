package org.cny.jutil.exp.limit;

import org.cny.jutil.exp.Exp;
import org.cny.jutil.exp.ILimit;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by cny on 7/11/14.
 */
public class O implements ILimit {
    private Set<Object> os = new HashSet<Object>();

    @Override
    public void valid(Exp exp, Object v) throws Exception {
        if (!this.os.contains(v)) {
            throw exp.error(String.format("value(%s) is not in (%s)", v, this.os));
        }
    }

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
