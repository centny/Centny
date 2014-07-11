package org.cny.jutil;

import junit.framework.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

/**
 * @author Centny. 7/11/14.
 */
public class AstTest {
    @Test
    public void testAssert() {
        yes_f(null);
        yes_f(0);
        yes_f(0L);
        yes_f(0D);
        yes_f(0F);
        yes_f(new Short((short) 0));
        yes_f(new Byte((byte) 0));
        yes_f("");
        yes_f(new ArrayList<String>());
        yes_f(new HashSet<String>());
        yes_f(new HashMap<String, String>());
        yes_f(new Object());
        //
        no(null);
        no(0);
        no(0L);
        no(0D);
        no(0F);
        no(new Short((short) 0));
        no(new Byte((byte) 0));
        no("");
        no(new ArrayList<String>());
        no(new HashSet<String>());
        no(new HashMap<String, String>());
        no(new Object());
        //
        yes(1);
        yes(1L);
        yes(1D);
        yes(1F);
        yes(new Short((short) 1));
        yes(new Byte((byte) 1));
        yes("abc");
        yes(new ArrayList<String>() {
            {
                add("aaa");
            }
        });
        yes(new HashSet<String>() {
            {
                add("abc");
            }
        });
        yes(new HashMap<String, String>() {
            {
                put("abcc", "ssss");
            }
        });
        //
        no_f(1);
        no_f(1L);
        no_f(1D);
        no_f(1F);
        no_f(new Short((short) 1));
        no_f(new Byte((byte) 1));
        no_f("abc");
        no_f(new ArrayList<String>() {
            {
                add("aaa");
            }
        });
        no_f(new HashSet<String>() {
            {
                add("abc");
            }
        });
        no_f(new HashMap<String, String>() {
            {
                put("abcc", "ssss");
            }
        });
        //
        new Ast();
    }

    private void yes_f(Object t) {
        try {
            Ast.yes(t, "error");
            Assert.fail();
        } catch (Exception e) {
        }
    }

    private void yes(Object t) {
        try {
            Ast.yes(t, "error");
        } catch (Exception e) {
            Assert.fail();
        }
    }

    private void no_f(Object t) {
        try {
            Ast.no(t, "error");
            Assert.fail();
        } catch (Exception e) {
        }
    }

    private void no(Object t) {
        try {
            Ast.no(t, "error");
        } catch (Exception e) {
            Assert.fail();
        }
    }
}
