// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";

// 이니셜라이징 계약서 OOP 클래스랑 비슷
// 즉 계약서 HEEJAE는 ERC721, ERC721Enumerable 스마트 계약서 등을 interitance 한다

contract HEEJAE is ERC721, ERC721Enumerable, ERC721URIStorage {

    // 카운터 라이브러리 이니셜라이징
    using Counters for Counters.Counter;

    // 카운터 변수를 private로 만든다 
    // private로 만들어진 변수, 함수 등 모든 것들은 이 계약서에서만 보이고 사용된다
    Counters.Counter private _tokenIdCounter;

    // ++ NFT 컬렉션보다 더 많은 민트를 못하게 막아주기
    uint256 MAX_SUPPLY = 10000;

    // 유저 민트 카운트위해 생성
    mapping(address => uint256) public userNFTCount;

    // 생성자로 ERC721 인스턴스 생성하면서 이름과 심볼 지정
    constructor() ERC721("HEEJAE", "HEJ") {}

    // 제일 중요!!
    // 새로운 NFT를 블록체인에 만드는 함수
    // address(nft 보낼 장소), token uri, id를 이용한다
    // public은 어디서든 접근 가능
    // onlyOwner: 스마트 계약서한테 이 스마트 계약서를 배포한 사람이 아니면 차단하라는 의미
    // 누구나 NFT 민트를 하게 하려면 onlyOnwer, import Ownable 지워주면 된다[삭제 완료]
    function safeMint(address to, string memory uri) public {

        // 5개 민트로 제한
        require(userNFTCount[msg.sender] < 5, "Cannot mint more than 5 NFTs");
        // 현재 토큰ID를 tokenId에 저장
        uint256 tokenId = _tokenIdCounter.current();
        // ++ NFT 컬렉션보다 더 많은 민트를 못하게 막아주기
        require(tokenId <= MAX_SUPPLY, "I'm sorry all NFTs have been minted");
        // NFT 카운트
        _tokenIdCounter.increment();
        // tokenId를 to로 안전하게 민트해준다
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        // 유저 민트 카운트 1 증가
        userNFTCount[msg.sender].increment();
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    // view를 지정해놓으면, 다른 스마트계약서가 아니라 본인 지갑에서 가져와서 No Gas Fee!
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}