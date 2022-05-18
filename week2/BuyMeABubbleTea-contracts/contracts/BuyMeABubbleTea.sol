//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract BuyMeABubbleTea {
    // 메모 만들어졌을때 실행되는(emit) 이벤트
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // 메모 구조.
    struct Memo{
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // 받은 모든 메모 리스트.
    Memo[] memos;

    // 컨트랙트 배포자 주소
    // 팁 인출할 때 사용
    address payable owner;

    // 로직 배포(한 번만 실행)
    constructor() {
        // 컨트랙트 배포한 메타마스크 주소, solidity msg 변수 사용 
        owner = payable(msg.sender);
    }

    /**
     * @dev 컨트랙트 오너위해 버블티 구매
     * @param _name 버블티 사는 사람 이름
     * @param _message 버블티 사는 사람이 쓰는 메시지
     */
    function buyBubbleTea(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "Can't buy bubble tea with 0 ETH");

        // 메모 저장
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // 새 메모 만들어지면, log 이벤트 실행
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    
    /**
     * @dev 밸런스 전체 이 컨트랙트 오너에게 보내기
     */
    function withdrawTips() public {
        // 이 컨트랙트 주소의 밸런스를 오너에게 보낸다.
        require(owner.send(address(this).balance));
    }

    /**
     * @dev 받고 블록체인에 저장된 모든 메모 가져오기
     */
    function getMemos() public view returns(Memo[] memory){
        return memos;
    }
}
