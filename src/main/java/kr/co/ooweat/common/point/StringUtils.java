package kr.co.ooweat.common.point;

import java.nio.charset.Charset;

public final class StringUtils {
    public static final char SPACE = ' ';

    public static final String STX ="\u0002";
    public static final String ETX ="\u0003";
    public static final String FS = "\u001C";
    public static final String GS = "\u001D";
    public static final String RS = "\u001E";
    public static final String US = "\u001F";
    public static final String ELLIPSIS = "…";
    public static final String EMPTY_STRING = "";

    public static final Charset EUC_KR = Charset.forName("EUC-KR");

    /**
     * 기본 생성자로 객체로 생성될 수 없도록 한다.
     *
     * 유틸리티 클래스는 모든 정적 함수로 생성될 필요가 없다.
     */
    private StringUtils() {}

    /**
     * 문자열의 뒷따르는 공백을 모두 제거한다.
     *
     * @param source 문자열
     *
     * @return 공백이 제거된 문자열
     */
    public static String trim(String source) {
        return (source == null ? null : source.trim());
    }

    /**
     * 문자열에 문자가 들어있는 가를 검사한다.
     *
     * @param source 문자열
     *
     * @return 문자 존재여부(true 또는 false)
     */
    public static boolean hasLength(String source) {
        return (source != null) && (source.length() > 0);
    }

    /**
     * 문자열에 공백 이외의 문자가 존재하는 가를 검사한다.
     *
     * @param source 문자열
     *
     * @return 공백이외의 문자 존재여부(true 또는 false)
     */
    public static boolean hasText(String source) {
        if (!hasLength(source)) return false;

        for (int i = 0;i < source.length();i++) {
            if (!Character.isWhitespace(source.charAt(i))) return true;
        }

        return false;
    }

    /**
     * 문자열을 주어진 횟수(count) 만큼 반복한 문자열을 생성한다.
     *
     * @param source 문자열
     * @param count 반복횟수
     *
     * @return 횟수만큼 반복된 문자열
     */
    public static String repeat(String source, int count) {
        if (!hasLength(source)) return source;
        if (count <= 0) return "";

        StringBuffer sb = new StringBuffer(source.length() * count);

        for (int i=0; i<count; i++) {
            sb.append(source);
        }

        return sb.toString();
    }

    /**
     * 문자열을 EUC-KR로 변환 시 주어진 바이트 수 이하로 줄이고, 줄어든 경우 생략부호를 붙인다.
     *
     * @param source 문자열
     * @param byteCount 바이트 수
     *
     * @return 주어진 바이트 수 이하로 생략된 문자열
     */
    public static String ellipsize(String source, int byteCount) {
        return ellipsize(source, byteCount, ELLIPSIS, EUC_KR);
    }

    /**
     * 문자열을 EUC-KR로 변환 시 주어진 바이트 수 이하로 줄이고, 줄어든 경우 생략부호를 붙인다.
     *
     * @param source 문자열
     * @param byteCount 바이트 수
     * @param ellipsis 생략부호
     *
     * @return 주어진 바이트 수 이하로 생략된 문자열
     */
    public static String ellipsize(String source , int byteCount, String ellipsis) {
        return ellipsize(source, byteCount, ellipsis, EUC_KR);
    }

    /**
     * 문자열을 대상 문자집하으로 변환 시 주어진 바이트 이하로 줄이고, 줄어든 경우 생략부호를 붙인다.
     *
     * @param source 문자열
     * @param byteCount 바이트 수
     * @param charset 대상 문자집합
     *
     * @return 주어진 바이트 수 이하로 생략된 문자열
     */
    public static String ellipsize(String source, int byteCount, Charset charset) {
        return ellipsize(source, byteCount, ELLIPSIS, charset);
    }

    /**
     * 문자열을 대상 문자집합으로 변환 시 주어진 바이트 수 이하로 줄이고 줄어든 경우 생략부호를 붙인다.
     *
     * 주의: 생략부호의 바이트 수가 전체 바이트 수보다 크지 않도록 한다.
     *
     * @param source 문자열
     * @param byteCount 바이트 수
     * @param charset 대상 문자집합
     *
     * @return 대상 바이트 수 이하로 생략된 문자열
     */
    public static String ellipsize(String source, int byteCount, String ellipsis, Charset charset) {
        if ((source == null) || (byteCount == 0)) return EMPTY_STRING;
        if (byteCount < 0) return source;

        int i = 0;
        int length = source.length();
        int bytesForLatin1 = "A".getBytes(charset).length;
        int bytesForKorean = "가".getBytes(charset).length;
        int bytesForEllipsis = ellipsis.toString().getBytes(charset).length;

        while ((i < length) && (byteCount >= 0)) {
            if (Character.getType(source.codePointAt(i)) == Character.OTHER_LETTER) {
                byteCount -= bytesForKorean;
            } else {
                byteCount -= bytesForLatin1;
            }
            i++;
        }

        if (byteCount >= 0) return source;

        while ((i > 0) && (byteCount < bytesForEllipsis)) {
            i--;
            if (Character.getType(source.codePointAt(i)) == Character.OTHER_LETTER) {
                byteCount += bytesForKorean;
            } else {
                byteCount += bytesForLatin1;
            }
        }

        return (source.substring(0, i) + ellipsis);
    }

    /**
     * 문자열을 EUC-KR로 변환 시 바이트 수에 맞추어 자르거나 SPACE를 채운다.
     *
     * 영문/기호 이외의 문자는 모두 2바이트(EUC-KR)로 계산한다.
     *
     * @param source 문자열
     * @param byteCount 바이트 수
     *
     * @return 조정된 문자열
     */
    public static String adjustByteCount(String source, int byteCount) {
        return adjustByteCount(source, byteCount, SPACE, EUC_KR);
    }

    /**
     * 문자열을 EUC-KR로 인코딩 시 바이트 수에 맞추어 자르거나 padding을 채운다.
     *
     * @param source 문자열
     * @param byteCount 바이트 수
     * @param padding 채울 글자
     *
     * @return 조정된 문자열
     */
    public static String adjustByteCount(String source, int byteCount, char padding) {
        return adjustByteCount(source, byteCount, padding, EUC_KR);
    }

    /**
     * 문자열을 대상 문자집합으로 변환될 시 바이트 수에 맞추어 자르거나 padding을 채운다.
     *
     * @param source 문자열
     * @param byteCount 바이트 수
     * @param charset 대상 문자집합
     *
     * @return 조정된 문자열
     */
    public static String adjustByteCount(String source, int byteCount, Charset charset) {
        return adjustByteCount(source, byteCount, SPACE, charset);
    }
    /**
     * 문자열을 대상 문자집합으로 변환될 시 바이트 수에 맞도록 자르거나 padding을 채운다.
     *
     * @param source 문자열
     * @param byteCount 바이트 수
     * @param padding 채울 글자
     * @param charset 대상 문자집합
     *
     * @return 조정된 문자열
     */
    public static String adjustByteCount(String source, int byteCount, char padding, Charset charset) {
        if (byteCount < 0) return source;
        if (byteCount == 0) return EMPTY_STRING;

        if (charset == null) charset = EUC_KR;
        if (source == null) source = EMPTY_STRING;

        int i = 0;
        int length = source.length();
        int bytesForLatin1 = "A".getBytes(charset).length;
        int bytesForKorean = "가".getBytes(charset).length;
        int bytesForPadding
                = Character.getType(padding) == Character.OTHER_LETTER
                ? bytesForKorean
                : bytesForLatin1
                ;

        while ((i < length) && (byteCount >= 0)) {
            if (Character.getType(source.codePointAt(i)) == Character.OTHER_LETTER) {
                byteCount -= bytesForKorean;
            } else {
                byteCount -= bytesForLatin1;
            }
            i++;
        }

        if (byteCount < 0) while ((i > 0) && (byteCount < 0)) {
            i--;
            if (Character.getType(source.codePointAt(i)) == Character.OTHER_LETTER) {
                byteCount += bytesForKorean;
            } else {
                byteCount += bytesForLatin1;
            }
        }

        StringBuilder builder = new StringBuilder(source.substring(0, i));
        while (byteCount > 0) {
            builder.append(padding);
            byteCount -= bytesForPadding;
        }
        return builder.toString();
    }


}
