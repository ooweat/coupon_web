package kr.co.ooweat.model;

import lombok.Data;

@Data
public class BizLogVO {
	String uniqueNo;
	String terminalId;
	String tranType;
	String msgType;
	String eventTime;
	String eventCode;
	String eventDesc;
	String crdtdt;
	String remoteAddr;
}
