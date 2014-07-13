package org.cny.jutil.exp.limit;

import org.cny.jutil.Ast;
import org.cny.jutil.exp.Exp;
import org.cny.jutil.exp.ILimit;

import java.util.regex.Pattern;

/**
 * pattern limit for string.
 *
 * @author Centny. 7/11/14.
 */
public class P implements ILimit {
    //the regex.
    private Pattern reg;
    //the regex string.
    private String regex;

    @Override
    public void valid(Exp exp, Object v) throws Exception {
        Ast.yes(v instanceof String, "not a string value");
        String val = (String) v;
        if (!this.reg.matcher(val).matches()) {
            throw exp.error(String.format("value(%s) not match regex(%s)", val, this.regex));
        }
    }

    /**
     * default constructor by regex express.
     *
     * @param regex regex express.
     */
    public P(String regex) {
        this.regex = regex;
        this.reg = Pattern.compile(regex);
    }
}