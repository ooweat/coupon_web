package kr.co.ooweat.common;

import static kr.co.ooweat.common.ResponseCode.ERROR_REQUEST;
import static kr.co.ooweat.common.ResponseCode.SUCCESS_REQUEST;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.reflect.Array;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;
import kr.co.ooweat.model.AlertModel;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@Slf4j
public class Util {
    
    public static final String ooweat_SECRET_KEY = "!ooweatSyStEaM!";
    private static final String keyBase64 = "DWIzFkO22qfVMgx2fIsxOXnwz10pRuZfFJBvf4RS3eY=";
    private static final String ivBase64 = "AcynMwikMkW4c7+mHtwtfw==";
    
    //날짜 & 시간 관련 Utils
    public static DateUtils dateUtils() {
        return new DateUtils();
    }
    
    public static class DateUtils {
        
        LocalDate now = LocalDate.now();
        public String firstDayOfMonth() {
            return (now.with(TemporalAdjusters.firstDayOfMonth()).toString().replace("-",""));
        }

        public String now() {
            return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        }
        
        public String yyyy() {
            return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy"));
        }
        
        public String MM() {
            return LocalDateTime.now().format(DateTimeFormatter.ofPattern("MM"));
        }
        
        public String yyyyMM() {
            return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMM"));
        }
        
        public String yyyyMM(int option) {
            String result = null;
            if (option == 0) {
                result = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMM"));
            } else if (option > 0) {    //NOTE: 미래
                result = LocalDateTime.now().plusMonths(option)
                    .format(DateTimeFormatter.ofPattern("yyyyMM"));
            } else if (option < 0) {    //NOTE: 과거
                option = option * -1;
                result = LocalDateTime.now().minusMonths(option)
                    .format(DateTimeFormatter.ofPattern("yyyyMM"));
            }
            return result;
        }
        
        //NOTE: 기존 Service 대응하기 위함.
        public String yyyyMMdd() {
            return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        }
        
        //NOTE: 범위 지정 시 Option 을 넣어 사용.
        public String yyyyMMdd(int dayOption) {
            return calcYYYYMMDD(dayOption);
        }
        
        public String yyyyMMddHH(int dayOption, int hourOption) {
            String day = null, hour = null;
            day = calcYYYYMMDD(dayOption);
            
            if (hourOption == 0) {
                hour = LocalDateTime.now().format(DateTimeFormatter.ofPattern("HH"));
            } else if (hourOption > 0) {    //NOTE: 미래
                hour = LocalDateTime.now().plusHours(hourOption)
                    .format(DateTimeFormatter.ofPattern("HH"));
            } else if (hourOption < 0) {    //NOTE: 과거
                hourOption = hourOption * -1;
                hour = LocalDateTime.now().minusHours(hourOption)
                    .format(DateTimeFormatter.ofPattern("HH"));
            }
            return day + hour;
        }
        
        public String calcYYYYMMDD(int option) {
            String day = null;
            if (option == 0) {
                day = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            } else if (option > 0) {    //NOTE: 미래
                day = LocalDateTime.now().plusDays(option)
                    .format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            } else if (option < 0) {    //NOTE: 과거
                option = option * -1;
                day = LocalDateTime.now().minusDays(option)
                    .format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            }
            return day;
        }
        
        public String hhmmss() {
            return LocalDateTime.now().format(DateTimeFormatter.ofPattern("HHmmss"));
        }
        
        public String hh() {
            //(('0' + (date.getMonth() + 1)).slice(-2))
            String hh = "0" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("HH"));
            return hh.substring(hh.length() - 2);
        }
        
        public int dayOfWeek() {
            return LocalDateTime.now().getDayOfWeek().getValue();
        }
        
    }
    
    //Response Util
    public static ResponseUtils responseUtils() {
        return new ResponseUtils();
    }
    
    public static class ResponseUtils {
        
        public static ResponseEntity<JSONObject> simpleReturn(String returnCode) {
            return new ResponseEntity<>(jsonUtils().simpleReturn(returnCode), HttpStatus.OK);
        }
        
        public static ResponseEntity<JSONObject> responseParsing(String code, String message,
            String description) {
            return new ResponseEntity<>(jsonUtils().responseParsing(code, message, description),
                HttpStatus.OK);
        }
        
        public static ResponseEntity<JSONObject> paramReturn(String returnCode, String param) {
            return new ResponseEntity<>(jsonUtils().paramReturn(returnCode, param), HttpStatus.OK);
        }
    }
    
    //Json return Util
    public static JsonUtils jsonUtils() {
        return new JsonUtils();
    }
    
    public static class JsonUtils {
        
        JSONObject json = new JSONObject();
        
        public JSONObject successParsing(Map map, AlertModel alertModel) {
            json.put("resultMsg", ResponseCode.SUCCESS_REQUEST.getMessage());
            json.put("type", alertModel.getTemplateType());
            return json;
        }
        
        public JSONObject responseParsing(String code, String message, String description) {
            JSONObject json = new JSONObject();
            json.put("code", code);
            json.put("message", message);
            json.put("description", description);
            return json;
        }
        
        public JSONObject simpleReturn(String returnCode) {
            json.put("resultMsg", ResponseCode.SUCCESS_REQUEST.getMessage());
            json.put("code", returnCode);
            return json;
        }
        
        public JSONObject paramReturn(String returnCode, String param) {
            json.put("resultMsg", ResponseCode.SUCCESS_REQUEST.getMessage());
            json.put("code", returnCode);
            json.put("param", param);
            return json;
        }
        
        public static JSONObject convertMapToJson(Map<String, Object> map) {
            JSONObject json = new JSONObject();
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                String key = entry.getKey();
                Object value = entry.getValue();
                json.put(key, value);
            }
            return json;
        }
    }
    
    //문자열 Util
    public static StringUtils stringUtils(String param) {
        return new StringUtils(param);
    }
    
    public static class StringUtils {
        
        private String value;
        
        public StringUtils(String value) {
            this.value = value;
        }
        
        //SQL 의 그것과 같음 in
        public boolean in(String... values) {
            for (String v : values) {
                if (v.equals(value)) {
                    return true;
                }
            }
            return false;
        }
        
        //SQL 의 그것과 같음 notIn
        public boolean notIn(String... values) {
            for (String v : values) {
                if (v.equals(value)) {
                    return false;
                }
            }
            return true;
        }
        
        public String convertMoneyFormat(){
            return NumberFormat.getInstance().format(Integer.parseInt(value));
        }
        
        /**
         * num : num 이하의 난수 생성
         *
         * @param num
         * @return
         */
        public static String rtnRnd(int num) {
            String rtnNum = "";
            String strNum = Integer.toString(num);
            int rnd = 0;
            try {
                //java.security.SecureRandom 클래스는 예측할 수 없는 seed를 이용하여 강력한 난수를 생성
                SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
                rnd = sr.nextInt(num);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            rtnNum = rtnAppendNumChar(rnd, "0", strNum.length());
            
            if (Long.parseLong(rtnNum) == 0) {
                rtnNum = null;
            }//
            
            return rtnNum;
        }
        
        /**
         * num 앞에 특정 숫자 붙이기
         *
         * @param iNum
         * @param ch
         * @param lim
         * @return
         */
        public static String rtnAppendNumChar(Integer iNum, String ch, int lim) {
            StringBuffer sb = new StringBuffer();
            String rtnData = "";
            int i = 0;
            if (iNum != null) {
                String txt_data = iNum.toString();
                if (txt_data.length() < lim) {
                    for (i = 0; i < lim - txt_data.length(); i++) {
                        sb.append(ch);
                    }//
                    sb.append(txt_data);
                    rtnData = sb.toString();
                } else {
                    rtnData = txt_data;
                }
            }//
            
            return rtnData;
        }
    }
    public static Boolean empty(Object obj) {
        if (obj instanceof String) return obj == null || "".equals(obj.toString().trim());
        else if (obj instanceof List) return obj == null || ((List) obj).isEmpty();
        else if (obj instanceof Map) return obj == null || ((Map) obj).isEmpty();
        else if (obj instanceof Object[]) return obj == null || Array.getLength(obj) == 0;
        else return obj == null;
    }
    
    public static Boolean notEmpty(Object obj) {
        return !empty(obj);
    }
    
    //에러
    public static String getError(String _methodName) {
        switch (_methodName) {
            case "loginConfirm":
            case "loginConfirmBingomu":
            case "loginConfirmMember":
                return " 계정정보를 확인해주세요. ";
            case "dashboard":
                return " 다시 로그인해주세요. ";
            default:
                return " 결과 값을 찾을 수 없습니다. Not Found Err";
        }
    }
    
    //컨펌
    public static String confirm(String target) {
        switch (target) {
            case "session":
                return "/common/confirm/sessionOut";
            case "logout":
                return "/common/confirm/logout";
            case "permission":
                return "/common/confirm/permission";
            case "accountErr":
                return "/common/confirm/accountErr";
            default:
                return null;
        }
    }
    
    public static String encrypt(String plaintext) throws Exception {
        log.info("#Encrypt Module Start");
        byte[] plaintextArray = plaintext.getBytes(StandardCharsets.UTF_8);
        byte[] keyArray = DatatypeConverter.parseBase64Binary(keyBase64);
        byte[] iv = DatatypeConverter.parseBase64Binary(ivBase64);
        SecretKeySpec secretKey = new SecretKeySpec(keyArray, "AES");
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
        cipher.init(1, secretKey, new IvParameterSpec(iv));
        return DatatypeConverter.printBase64Binary(cipher.doFinal(plaintextArray));
        //return new String(DatatypeConverter.printBase64Binary(cipher.doFinal(plaintextArray)));
    }
    
    public static String decrypt(String ciphertext) throws Exception {
        log.info("#Decrypt Module Start");
        byte[] ciphertextArray = DatatypeConverter.parseBase64Binary(ciphertext);
        byte[] keyArray = DatatypeConverter.parseBase64Binary(keyBase64);
        byte[] iv = DatatypeConverter.parseBase64Binary(ivBase64);
        SecretKeySpec secretkey = new SecretKeySpec(keyArray, "AES");
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
        cipher.init(2, secretkey, new IvParameterSpec(iv));
        return new String(cipher.doFinal(ciphertextArray));
    }
    
    //전문 TCP 전송
    public static int tcpSend() {
        return 0;
    }
    
    public static String encryptAES256(String msg) throws Exception {
        SecureRandom random = new SecureRandom();
        byte bytes[] = new byte[20];
        random.nextBytes(bytes);
        byte[] saltBytes = bytes;
        
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        PBEKeySpec spec = new PBEKeySpec(ooweat_SECRET_KEY.toCharArray(), saltBytes, 70000, 256);
        
        SecretKey secretKey = factory.generateSecret(spec);
        SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");
        
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, secret);
        AlgorithmParameters params = cipher.getParameters();
        byte[] ivBytes = params.getParameterSpec(IvParameterSpec.class).getIV();
        byte[] encryptedTextBytes = cipher.doFinal(msg.getBytes("UTF-8"));
        byte[] buffer = new byte[saltBytes.length + ivBytes.length + encryptedTextBytes.length];
        System.arraycopy(saltBytes, 0, buffer, 0, saltBytes.length);
        System.arraycopy(ivBytes, 0, buffer, saltBytes.length, ivBytes.length);
        System.arraycopy(encryptedTextBytes, 0, buffer, saltBytes.length + ivBytes.length,
            encryptedTextBytes.length);
        
        return Base64.getEncoder().encodeToString(buffer);
    }
    
    public static String AES256Security2(String type, String data) {
        String aesData = "";
        
        try {
            AES256Util aes = new AES256Util();
            if ("enc".equals(type)) {
                aesData = aes.encrypt(data);
                log.debug("암호화 체크 : " + aesData);
            } else if ("dec".equals(type)) {
                aesData = aes.decrypt(data);
                log.debug("복호화 체크 : " + aesData);
            } else {
                aesData = aes.encrypt(data);
                log.debug("복호화 체크 : " + aesData);
            }
        } catch (Exception var6) {
            log.debug("암복호화 오류" + var6.toString());
        }
        return aesData;
    }
    
    public static ResponseEntity<JSONObject> callCouponApi(JSONObject couponObject){
        String apiUrl = "http://api.ooweat.co.kr/coupon_web/coupon/issuance";
        try {
            HttpURLConnection conn = null;
            URL url = new URL(apiUrl);
            conn = (HttpURLConnection) url.openConnection();
    
            conn.setRequestMethod("POST");//POST GET
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("token", (String) couponObject.get("token"));
            conn.setRequestProperty("company", String.valueOf(couponObject.get("companySeq")));
            conn.setRequestProperty("charset", "UTF-8");
    
            //POST방식으로 스트링을 통한 JSON 전송
            conn.setDoOutput(true);
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
    
            bw.write(couponObject.toString());
            bw.flush();
            bw.close();
    
            //서버에서 보낸 응답 데이터 수신 받기
            BufferedReader in = new BufferedReader(
                new InputStreamReader(
                    conn.getInputStream()));
            String returnMsg = in.readLine();
            System.out.println("응답메시지 : " + returnMsg);
            //HTTP 응답 코드 수신
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    SUCCESS_REQUEST.getCode(), SUCCESS_REQUEST.getMessage(), SUCCESS_REQUEST.getDescription()), HttpStatus.OK);
            } else {
                return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                    ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(), ERROR_REQUEST.getDescription()), HttpStatus.OK);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(Util.jsonUtils().responseParsing(
                ERROR_REQUEST.getCode(), ERROR_REQUEST.getMessage(),
                ERROR_REQUEST.getDescription()), HttpStatus.OK);
        }
    }
}
