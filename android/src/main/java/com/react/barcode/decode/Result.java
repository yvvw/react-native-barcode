package com.react.barcode.decode;

public class Result {
    public static final String Type = "type";
    public static final String Content = "content";

    private final int raw;
    private final String content;

    Result(int raw, String content) {
        this.raw = raw;
        this.content = content;
    }

    public int getRaw() {
        return raw;
    }

    public String getContent() {
        return content;
    }

    @Override
    public String toString() {
        return "Result{" +
                Type + "=" + raw +
                ", " + Content + "='" + content + '\'' +
                '}';
    }

    public boolean equals(Result o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        return this.raw == o.raw && this.content.equals(o.content);
    }
}
