//Hnbc contract
contract Hnbc
{
    //���Ѷ���
    struct Fee {
        uint usertype; //�û�״̬, 1����ͨ��Ա��2������������Ա�� 
        uint lastTime; //���ɷ�����
        uint allMoney;  //�ɷ��ܽ��
        uint insuranceMoney; //���뱣���ܽ��
        uint financingMoney; //����ܽ��
        uint leftMoney;//��ǰ���
        uint exists;//�Ƿ����,1����
        mapping(bytes32 => uint) insuranceApply;//���뱣����Ϣid
        mapping(bytes32 => uint) insurancePay;//֧��������Ϣid
        mapping(bytes32 => uint) financingApply;//��������Ϣid
        mapping(bytes32 => uint) financingPay;//֧�������Ϣid
        bytes32[] financingAssureId;//������Լid
    }

    //���뱣���������
    struct Insurance {  
        address applyAddr; //�����˵�ַ
        uint insuranceApply; //���뱣����Ʒ��ܽ��
        uint applyState; //����״̬ 1�����룻2������ɹ�; 3,����û�֧���ɹ�; 4,����ʧ��
        uint insurancePay;//�ɹ�֧�����
        mapping(address => uint) feeInfoByAddr;// ֧���ˣ�֧�����
        address insuranceChecker; //������������˵�ַ
        bytes32 applyData; //����������Ϣhashֵ
        uint applyTime; //����ʱ��
        uint passTime;//ͨ��ʱ��
        uint payTime; //֧��ʱ��
        uint exists;//�Ƿ����,1����
    }
   
    //���뻥���������
    struct Financing {
        address applyAddr; //�����˵�ַ
        uint usertype; //�û�״̬, 1����ͨ��Ա��2������������Ա�� 
        uint financingApply; //�������ܽ��
        uint creditMoney; //������������
        uint applyState; //����״̬ 1�����룻2,�����ɹ�; 3������ɹ�; 4,����û�֧���ɹ�; 5,����ʧ��
        uint financingPay;//�ɹ�֧�����
        uint returnMoney; //�ɹ�������
        mapping(address => uint) feeInfoByAddr;// ֧���ˣ�֧�����
        address[] feeInfoKeys;//֧���˵����е�ַ
        address creditEvaluater; //���������˵�ַ
        address assureAddr; // �����˵�ַ
        bytes32 applyData; //����������Ϣhashֵ
        uint applyTime; //����ʱ��
        uint passTime;//ͨ��ʱ��
        uint payTime; //֧��ʱ��
        uint assureTime; //����ʱ��
        uint exists;//�Ƿ����,1����
    }
   
    //��������˶���
    struct InsuranceChecker {
        bytes32[] insurancesKeys;//��Լ���
        uint exists;//�Ƿ����,1����
    }
   
    //���������˶���
    struct CreditEvaluater {
        bytes32[] financingKeys;//��Լ���
        uint exists;//�Ƿ����,1����
    }

    address public organizer; //��Լ��ʼ��
    uint public minTicket;//��С�������
    uint public minFee;//��Сÿ�·���
    uint public maxInsuranceTimes;//��߱��ձ���
    uint public maxFinancingTimes; //��߽������
    uint public maxInsuranceRate;//��߱�����������
    uint public maxFinancingRate;//��߽����������
    uint public totalAllMoney;  //ϵͳ�ɷ��ܽ��
    uint public totalLeftMoney; //ϵͳ��ʣ�����
    uint public totalInsuranceMoney; //ϵͳ����֧���ܽ��
    uint public totalFinancingMoney; //ϵͳ���֧���ܽ��
    uint public totalInsuranceNum; //ϵͳ����֧������
    uint public totalFinancingNum; //ϵͳ���֧������
   
    mapping(address => InsuranceChecker) public insuranceCheckers;//���ڱ��������������Ϣ,uintΪ����������������
    mapping(address => CreditEvaluater) public creditEvaluaters;//���ڱ���������������Ϣ,uintΪ������������������
    mapping(address => Fee) public fees;//���ڴ洢�û����ɱ�����Ϣ
    address[] feeKeys;//�û��洢����typeΪ1���û���keyֵ
   
    mapping(bytes32 => Insurance) public insurances;//���ڴ洢���뱣��������Ϣ
    mapping(bytes32 => Financing) public financings;//���ڴ洢���������Ϣ
   
    function Hnbc(uint _minTicket, uint _minFee, uint _maxInsuranceTimes,
                  uint _maxFinancingTimes, uint _maxInsuranceRate, uint _maxFinancingRate) {
        organizer = msg.sender;
        minTicket = _minTicket;
        minFee = _minFee;
        maxInsuranceTimes = _maxInsuranceTimes;
        maxFinancingTimes = _maxFinancingTimes;   
        maxInsuranceRate = _maxInsuranceRate;
        maxFinancingRate = _maxFinancingRate;
       
        totalAllMoney = 0;
        totalLeftMoney = 0;
        totalInsuranceMoney = 0;
        totalFinancingMoney = 0;
        totalInsuranceNum = 0;
        totalFinancingNum = 0;
    }
   
   
   
    //�����û�
    function createCommonUser(uint usertype) public returns (bool success) {
        if (usertype != 1 && usertype != 2){
            return false;
        }
        else if (fees[msg.sender].exists == 0 ){
            if (usertype == 1 || usertype == 2){
                fees[msg.sender].usertype = usertype;
                fees[msg.sender].allMoney = 0;
                fees[msg.sender].exists = 1;
                if (usertype == 1) {
                    feeKeys.push(msg.sender);
                }
                return true;   
            } else {
            return false;
        }
        } else {
            return false;
        }
    }
   
    //�������ղ�������û�
    function createInsuranceChecker(bytes32 info) public returns (bool success) {
       
        //���ղ����������Ҫ��Լ������һ�����
        if (info != sha3(organizer, msg.sender)) {
            return false;
        } else if (insuranceCheckers[msg.sender].exists != 0){
            return false;
        } else{
            insuranceCheckers[msg.sender].exists = 1;
            return true;
        }
    }
   
    //������������������û�
    function createCreditEvaluaters(bytes32 info) public returns (bool success) {
       
        //���������������Ҫ��Լ������һ�����
        if (info != sha3(organizer, msg.sender)) {
            return false;
        } else if (creditEvaluaters[msg.sender].exists != 0){
            return false;
        } else{
            creditEvaluaters[msg.sender].exists = 1;
            return true;
        }
    }
   
    //���ɻ��
    function payTicket(uint ticket) public returns (bool success) {
       
        if (ticket < minTicket) {
            return false;
        //����û�Ա��Ϣ�����ڻ���Ϊ�Ǳ�׼��Ա
        } else if (fees[msg.sender].exists == 0){
            return false;
        } else {
            if (!organizer.send(ticket)) {
                throw;
            }
            fees[msg.sender].exists = 1;
            fees[msg.sender].allMoney = ticket;
            fees[msg.sender].leftMoney = ticket;
            fees[msg.sender].insuranceMoney = 0;
            fees[msg.sender].financingMoney = 0;
            fees[msg.sender].lastTime = now;
            totalAllMoney += ticket;
            totalLeftMoney += ticket;
        }
    }
   

    //ÿ�½��ɻ��
    function payFee(uint fee) public returns (bool success)  {
       
        if (fee < minFee) {
            return false;
        } else if (fees[msg.sender].exists == 0 || fees[msg.sender].usertype != 1){
            return false;
            // �м���30��
        } else if (now < fees[msg.sender].lastTime + 30 days){
            return false;
        } else {
            if (!organizer.send(fee)) {
                throw;
            }
            fees[msg.sender].allMoney += fee;
            fees[msg.sender].leftMoney += fee;
            fees[msg.sender].lastTime = now;
            totalAllMoney += fee;
            totalLeftMoney += fee;
        }
    }
   
    //���뱣���������
    function  applyInsurance(uint insuranceApply) public returns (bytes32 applyId)  {
       
        if (fees[msg.sender].exists == 0){
            return 0;
        } else if (fees[msg.sender].usertype != 1){
            return 0;
        }
        // ���������ɷѣ�ͨ�����ɷ�ʱ���ж�
        else if (now > fees[msg.sender].lastTime + 30 days){
            return 0;
        } else {
            bytes32 insuranceApplyId = sha3(msg.sender, insuranceApply, now);
            if (insurances[insuranceApplyId].exists == 0){
                //�����±��ն���
                insurances[insuranceApplyId].applyAddr = msg.sender;
                insurances[insuranceApplyId].insuranceApply = insuranceApply;
                insurances[insuranceApplyId].applyState = 1;
                insurances[insuranceApplyId].applyTime = now;
                insurances[insuranceApplyId].exists = 1;
                return insuranceApplyId;
            } else{
                return 0;
            }   
        }
    }
   
    //�������ϵ�����ȷ�����
    function checkInsuranceFiles(bytes32 insuranceApplyId, address applyAddr, bytes32 applyData, uint applyState) public returns (bool success) {
       
        if (insurances[insuranceApplyId].exists != 1 || insurances[insuranceApplyId].applyState != 1){
            return false;
        } else if (insuranceCheckers[msg.sender].exists == 0){
            return false;
        //���һ�µ�ַ�Ƿ���ȷ���Ƿ���Ͷ���˵�ַ
        } else if (insurances[insuranceApplyId].applyAddr != applyAddr){
            return false;
        } else {
            //applyState ֻ��Ϊ 2�ɹ� ���� 4ʧ��
            if (applyState == 2 || applyState == 4){
                insuranceCheckers[msg.sender].insurancesKeys.push(insuranceApplyId);
                insurances[insuranceApplyId].insuranceChecker = msg.sender;
                insurances[insuranceApplyId].applyData = applyData;
                insurances[insuranceApplyId].passTime = now;
                insurances[insuranceApplyId].applyState = applyState;
            }   
        }
    }
   
    //ϵͳ���û����б��տ۷�
    function chargeInsuranceMoney(bytes32 insuranceApplyId, address applyAddr) public returns (bool success) {
       
        if (insurances[insuranceApplyId].exists != 1){
            return false;
        } else if (msg.sender != organizer){
            return false;
        //���һ�µ�ַ�Ƿ���ȷ���Ƿ���Ͷ���˵�ַ
        } else if (insurances[insuranceApplyId].applyAddr != applyAddr){
            return false;
        //ֻ�е���ǰ    applyStateΪ2������ɹ���ʱ�����֧��
        } else if (insurances[insuranceApplyId].applyState != 2){
            return false;
        }  else {
           
            Fee fee = fees[insurances[insuranceApplyId].applyAddr];
            //���㵱ǰ�Ƿ񳬹������䱣����������
            uint maxInsuranceNum = feeKeys.length / maxInsuranceRate;
            if (totalInsuranceNum < maxInsuranceNum){
                totalInsuranceNum += 1;
            } else{
                return false;
            }
           
            //���㵱ǰ����Ͷ���ܽ���������
            uint maxInsurance = maxInsuranceTimes * (fee.allMoney - fee.insuranceMoney - fee.financingMoney);
            uint availMoney = totalAllMoney - totalInsuranceMoney - totalFinancingMoney;
            //�õ�ʵ�ʿ��Է��ŵĶ�ȣ�ȡС��
            uint sendMoney = maxInsurance;
            if (maxInsurance > insurances[insuranceApplyId].insuranceApply){
                sendMoney = insurances[insuranceApplyId].insuranceApply;
            }
            if (sendMoney > 0){
                uint availTimes = availMoney / sendMoney;
                if (availTimes > 0){
                    //��ʼ��ÿ���˵��˻����п۷�   
                    uint insurancePay = 0;
                    for (uint i = 1; i <= feeKeys.length; i++) {
                        address feeKey = feeKeys[i];   
                        uint payMoney = fees[feeKey].leftMoney/availTimes;
                        fees[feeKey].leftMoney -= payMoney;
                        //����ÿ���˵�֧�����
                        fees[feeKey].insurancePay[insuranceApplyId] = payMoney;
                        insurances[insuranceApplyId].feeInfoByAddr[feeKey] = payMoney;
                        insurancePay += payMoney;       
                    }
                    insurances[insuranceApplyId].applyState = 3;
                    insurances[insuranceApplyId].insurancePay = insurancePay;
                    insurances[insuranceApplyId].payTime = now;
                    fees[applyAddr].insuranceApply[insuranceApplyId] = insurancePay;
                    fees[applyAddr].insuranceMoney += insurancePay;
                    totalInsuranceMoney += insurancePay;
                    totalLeftMoney -= insurancePay;
                    totalInsuranceNum += 1;
					applyAddr.send(insurancePay);                
                }
            }
        }
       
    }

    //����������
    function  applyFinancing(uint financingApply) public returns (bytes32 applyId)  {
       
        if (fees[msg.sender].exists == 0){
            return 0;
        }
        // ���typeΪ1������������ɷѣ�ͨ�����ɷ�ʱ���ж�
        else if (fees[msg.sender].usertype == 1 && now > fees[msg.sender].lastTime + 30 days){
            return 0;
        } else {
            bytes32 financingApplyId = sha3(msg.sender, financingApply, now);
            if (financings[financingApplyId].exists == 0){
                //��������ƶ���
                financings[financingApplyId].applyAddr = msg.sender;
                financings[financingApplyId].financingApply = financingApply;
                financings[financingApplyId].usertype = fees[msg.sender].usertype;
                financings[financingApplyId].applyState = 1;
                financings[financingApplyId].applyTime = now;
                financings[financingApplyId].exists = 1;
                //�������ͨ�û������Լ����Լ�����
                if (fees[msg.sender].usertype == 1){
                    financings[financingApplyId].assureAddr = msg.sender;
                    financings[financingApplyId].applyState = 2;
                    financings[financingApplyId].assureTime = now;
                    fees[msg.sender].financingAssureId.push(financingApplyId);
                }
                return financingApplyId;
            } else{
                return 0;
            }   
        }
    }

    //����û�����������
    function financingAssure(bytes32 financingApplyId, address applyAddr) public returns (bool success) {
        if (financings[financingApplyId].exists != 1 || financings[financingApplyId].applyState != 1){
            return false;
        }
        //��ǰ�����˱��������ɷ�
        else if (now > fees[msg.sender].lastTime + 30 days){
            return false;
        //���һ�µ�ַ�Ƿ���ȷ���Ƿ���Ͷ���˵�ַ
        } else if (financings[financingApplyId].applyAddr != applyAddr){
            return false;
        } else {
            financings[financingApplyId].assureAddr = msg.sender;
            financings[financingApplyId].applyState = 2;
            financings[financingApplyId].assureTime = now;
            fees[msg.sender].financingAssureId.push(financingApplyId);
        }
    }
       
    //������ϵ�������������ȷ�����
    function evaluaterCreditFiles(bytes32 financingApplyId, address applyAddr, bytes32 applyData, uint applyState, uint creditMoney) public returns (bool success) {
        //����������������
        if (financings[financingApplyId].exists != 1 || financings[financingApplyId].applyState != 2){
            return false;
        } else if (insuranceCheckers[msg.sender].exists == 0){
            return false;
        //���һ�µ�ַ�Ƿ���ȷ���Ƿ���Ͷ���˵�ַ
        } else if (financings[financingApplyId].applyAddr != applyAddr){
            return false;
        } else {
            //applyState ֻ��Ϊ 3�ɹ� ���� 5ʧ��
            if (applyState == 3 || applyState == 5){
                creditEvaluaters[msg.sender].financingKeys.push(financingApplyId);
                financings[financingApplyId].creditEvaluater = msg.sender;
                financings[financingApplyId].applyData = applyData;
                financings[financingApplyId].passTime = now;
                financings[financingApplyId].applyState = applyState;
                financings[financingApplyId].creditMoney = creditMoney;
            }   
        }
    }
   
    //ϵͳ���û�������ƿ۷�
    function chargeFinancingMoney(bytes32 financingApplyId, address applyAddr) public returns (bool success) {
       
        if (financings[financingApplyId].exists != 1){
            return false;
        } else if (msg.sender != organizer){
            return false;
        //���һ�µ�ַ�Ƿ���ȷ���Ƿ�������˵�ַ
        } else if (financings[financingApplyId].applyAddr != applyAddr){
            return false;
        //ֻ�е���ǰ    applyStateΪ3������ɹ���ʱ�����֧��
        } else if (financings[financingApplyId].applyState != 3){
            return false;
        } else {
            //ʹ�õ����˵Ķ��
            Fee fee = fees[financings[financingApplyId].assureAddr];
            //���㵱ǰ�Ƿ񳬹������������������
            uint maxFinancingNum = feeKeys.length / maxFinancingRate;
            if (totalFinancingNum < maxFinancingNum){
                totalFinancingNum += 1;
            } else{
                return false;
            }
           
            //���㵱ǰ��������ܽ���������
            uint maxFinancing = maxFinancingTimes * (fee.allMoney - fee.insuranceMoney - fee.financingMoney);       
            uint availMoney = totalAllMoney - totalInsuranceMoney - totalFinancingMoney;
            //�õ�ʵ�ʿ��Է��ŵĶ�ȣ�ȡС��
            uint sendMoney = maxFinancing;
            if (maxFinancing > financings[financingApplyId].financingApply){
                if ( financings[financingApplyId].financingApply > financings[financingApplyId].creditMoney){
                    sendMoney = financings[financingApplyId].creditMoney;
                } else{
                    sendMoney = financings[financingApplyId].financingApply;
                }
            } else if (maxFinancing  > financings[financingApplyId].creditMoney){
                sendMoney = financings[financingApplyId].creditMoney;
            }
           
            if (sendMoney > 0){
                uint availTimes = availMoney / sendMoney;
                if (availTimes > 0){
                    //��ʼ��ÿ���˵��˻����п۷�   
                    uint financingPay = 0;
                    for (uint i = 1; i <= feeKeys.length; i++) {
                        address feeKey = feeKeys[i];
                        uint payMoney = fees[feeKey].leftMoney/availTimes;
                        fees[feeKey].leftMoney -= payMoney;
                        //����ÿ���˵�֧�����
                        fees[feeKey].financingPay[financingApplyId] = payMoney;
                        financings[financingApplyId].feeInfoByAddr[feeKey] = payMoney;
                        financings[financingApplyId].feeInfoKeys.push(feeKey);
                        financingPay += payMoney;
                    }
                    financings[financingApplyId].applyState = 4;
                    financings[financingApplyId].financingPay = financingPay;
                    financings[financingApplyId].returnMoney = 0;
                    financings[financingApplyId].payTime = now;
                    fees[applyAddr].financingApply[financingApplyId] = financingPay;
                    //�����˵Ķ������
                    fees[financings[financingApplyId].assureAddr].financingMoney += financingPay;
                    totalFinancingMoney += financingPay;
                    totalLeftMoney -= financingPay;
					applyAddr.send(financingPay);       
                }
            }
        }
       
    }

    //����û�����
    function returnFinancingMoney(bytes32 financingApplyId, uint returnMoney) public returns (bool success) {
       
        if (!organizer.send(returnMoney)) {
            throw;
        }
        if (financings[financingApplyId].exists != 1){
            return false;
        //���һ�µ�ַ�Ƿ���ȷ���Ƿ�������˵�ַ
        } else if (financings[financingApplyId].applyAddr != msg.sender){
            return false;
        //ֻ�е���ǰ    applyStateΪ4��֧���ɹ���ʱ����ܻ���
        } else if (financings[financingApplyId].applyState != 3){
            return false;
        }  else {
            //�жϻ�ʣ�¶��ٻ�����
            uint leftMoney = financings[financingApplyId].financingPay - financings[financingApplyId].returnMoney;
            uint payMoney = leftMoney - returnMoney;
            //���payMoney�����ʾ����֮���ж����Ǯ����������˻�
            if (payMoney < 0){
                //�Ȼ�leftMoney��ծȨ���˻�
                uint financingPay = 0;
                for (uint i = 1; i <= financings[financingApplyId].feeInfoKeys.length; i++) {
                    address feeKey = financings[financingApplyId].feeInfoKeys[i];
                    uint payReturnMoney = financings[financingApplyId].feeInfoByAddr[feeKey] / financings[financingApplyId].financingPay * leftMoney;
                    fees[feeKey].leftMoney += payReturnMoney;
                    financingPay += payReturnMoney;
                }
                payMoney = returnMoney - financingPay;
                //ʣ��Ĵ�������˻�
                fees[msg.sender].leftMoney += payMoney;
            } else {
                //����returnMoney��ծȨ�˸����˻�
                financingPay = 0;
                i = 1;
                for (; i < financings[financingApplyId].feeInfoKeys.length; i++) {
                    feeKey = financings[financingApplyId].feeInfoKeys[i];
                    payReturnMoney = financings[financingApplyId].feeInfoByAddr[feeKey] / financings[financingApplyId].financingPay * returnMoney;
                    fees[feeKey].leftMoney += payReturnMoney;
                    financingPay += payReturnMoney;
                }       
                feeKey = financings[financingApplyId].feeInfoKeys[i];
                payReturnMoney = returnMoney - financingPay;
                fees[feeKey].leftMoney += payReturnMoney;
            }
           
        }
   
    }
   
    //��ѯ�����ʲ����
    function showUserAllMoney(address applyAddr) public returns (uint allMoney) {
       
        if (msg.sender != applyAddr){
            return 0;
        }
        else if (fees[msg.sender].exists == 0 || fees[msg.sender].usertype != 1){
            return fees[msg.sender].allMoney;
        }else {
            return 0;
        }
    }
   
    //��ѯ���˱��������ܽ�����
    function showUserInsuranceMoney(address applyAddr) public returns (uint insuranceMoney) {
       
        if (msg.sender != applyAddr){
            return 0;
        }
        else if (fees[msg.sender].exists == 0 || fees[msg.sender].usertype != 1){
            return fees[msg.sender].insuranceMoney;
        }else {
            return 0;
        }
    }
   
    //��ѯ��������ܽ�����
    function showUserFinancingMoney(address applyAddr) public returns (uint financingMoney) {
       
        if (msg.sender != applyAddr){
            return 0;
        }
        else if (fees[msg.sender].exists == 0 ){
            return fees[msg.sender].financingMoney;
        }else {
            return 0;
        }
    }
   
    //��ѯ�����ʲ����
    function showUserLeftMoney(address applyAddr) public returns (uint leftMoney) {
       
        if (msg.sender != applyAddr || fees[msg.sender].usertype != 1){
            return 0;
        }
        else if (fees[msg.sender].exists == 0 ){
            return fees[msg.sender].leftMoney;
        }else {
            return 0;
        }
    }
   
    function destroy() { // so funds not locked in contract forever
        if (msg.sender == organizer) {
            suicide(organizer); // send funds to organizer
        }
    }
}