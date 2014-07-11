package org.cny.jutil.exp;

import org.cny.jutil.Ast;
import org.cny.jutil.exp.limit.L;
import org.cny.jutil.exp.limit.O;
import org.cny.jutil.exp.limit.P;
import org.cny.jutil.exp.limit.R;

/**
 * @author Centny.
 */
public class Exp {
    public enum ReqType {
        R, O
    }

    public enum ValType {
        I, F, S
    }

    public enum LType {
        L, P, R, O
    }

    private ReqType rtype;
    private ValType vtype;
    private String limit;
    private ILimit l;
    private String msg;

    private Exp() {
    }

    public static Exp compile(String exp) {
        Ast.yes(exp, "the express is null or empty");
        String[] es = exp.split(",", 3);
        Ast.no(es.length < 2, "invalid express:" + exp);
        if (es.length == 3) {
            return compile(es[0], es[1], es[2]);
        } else {
            return compile(es[0], es[1], null);
        }
    }

    public static Exp compile(String rt, String limit, String msg) {
        Ast.yes(rt, "require and value type express is null or empty");
        String[] rst = rt.split("\\|", 2);
        Ast.yes(rst.length == 2, "invalid require and value type express(%s)", rt);
        Exp exp = new Exp();
        exp.rtype = ReqType.valueOf(rst[0]);
        exp.vtype = ValType.valueOf(rst[1]);
        exp.msg = msg;
        //
        Ast.yes(limit, "limit express is null or empty");
        String[] ls = limit.split("\\:", 2);
        Ast.yes(ls.length == 2, "invalid limit express(%s)", limit);
        exp.limit = ls[1];
        LType lt = LType.valueOf(ls[0]);
        switch (lt) {
            case L:
                exp.l = new L(ls[1]);
                break;
            case O:
                exp.l = new O(ls[1], exp.vtype);
                break;
            case P:
                exp.l = new P(ls[1]);
                break;
            default:
                exp.l = new R(ls[1]);
                break;

        }
        return exp;
    }

    public Object valid(Object v) throws Exception {
        if (v == null) {
            if (this.rtype.equals(ReqType.R)) {
                throw this.error("value is null or empty");
            } else {
                return null;
            }
        }
        Object t;
        switch (this.vtype) {
            case I:
                t = this.valid_i(v);
                break;
            case F:
                t = this.valid_f(v);
                break;
            default:
                t = this.valid_s(v);
                break;
        }
        this.l.valid(this, t);
        return t;
    }

    private Object valid_i(Object v) {
        if (v instanceof Number) {
            Number num = (Number) v;
            return num.intValue();
        } else {
            return Integer.parseInt(v.toString());
        }
    }

    private Object valid_f(Object v) {
        if (v instanceof Number) {
            Number num = (Number) v;
            return num.floatValue();
        } else {
            return Float.parseFloat(v.toString());
        }
    }

    private Object valid_s(Object v) {
        return v.toString();
    }

    public ReqType getRtype() {
        return rtype;
    }

    public ValType getVtype() {
        return vtype;
    }

    public ILimit getL() {
        return l;
    }

    public String getLimit() {
        return limit;
    }

    public String getMsg() {
        return msg;
    }

    public RuntimeException error(String msg) {
        return new RuntimeException(this.msg, new RuntimeException(msg));
    }
}
