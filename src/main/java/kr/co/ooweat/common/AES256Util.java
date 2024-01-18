package kr.co.ooweat.common;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;
import java.nio.charset.StandardCharsets;

public class AES256Util {
    private String keyBase64 = "DWIzFkO22qfVMgx2fIsxOXnwz10pRuZfFJBvf4RS3eY=";
    private String ivBase64 = "AcynMwikMkW4c7+mHtwtfw==";

    public AES256Util() {
    }

    public String encrypt(String plaintext) throws Exception {
        byte[] plaintextArray = plaintext.getBytes(StandardCharsets.UTF_8);
        byte[] keyArray = DatatypeConverter.parseBase64Binary(this.keyBase64);
        byte[] iv = DatatypeConverter.parseBase64Binary(this.ivBase64);
        SecretKeySpec secretKey = new SecretKeySpec(keyArray, "AES");
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
        cipher.init(1, secretKey, new IvParameterSpec(iv));
        return new String(DatatypeConverter.printBase64Binary(cipher.doFinal(plaintextArray)));
    }

    public String decrypt(String ciphertext) throws Exception {
        byte[] ciphertextArray = DatatypeConverter.parseBase64Binary(ciphertext);
        byte[] keyArray = DatatypeConverter.parseBase64Binary(this.keyBase64);
        byte[] iv = DatatypeConverter.parseBase64Binary(this.ivBase64);
        SecretKeySpec secretkey = new SecretKeySpec(keyArray, "AES");
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
        cipher.init(2, secretkey, new IvParameterSpec(iv));
        return new String(cipher.doFinal(ciphertextArray));
    }
}
