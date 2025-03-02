{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.gpg = {
    enable = true;

    # 기본 GPG 패키지 대신 특정 버전 사용
    package = pkgs.gnupg;

    # GPG 설정 디렉토리 지정 (기본값은 ~/.gnupg)
    homedir = "${config.home.homeDirectory}/.gnupg";

    # 사용자가 키 관리를 할 수 있도록 설정
    mutableKeys = true;

    # 사용자가 신뢰도 관리를 할 수 있도록 설정
    mutableTrust = true;

    # GPG 환경 설정
    settings = {
      # 암호화 알고리즘 선호도
      personal-cipher-preferences = "AES256 AES192 AES";

      # 해시 알고리즘 선호도
      personal-digest-preferences = "SHA512 SHA384 SHA256";

      # 압축 알고리즘 선호도
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";

      # 기본 선호도 목록
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";

      # 인증서 다이제스트 알고리즘
      cert-digest-algo = "SHA512";

      # S2K 다이제스트 알고리즘
      s2k-digest-algo = "SHA512";

      # S2K 암호화 알고리즘
      s2k-cipher-algo = "AES256";

      # 문자셋 설정
      charset = "utf-8";

      # 고정 리스트 모드 활성화
      fixed-list-mode = true;

      # 주석 제외
      no-comments = true;

      # 버전 정보 제외
      no-emit-version = true;

      # 키 ID 형식 설정
      keyid-format = "0xlong";

      # 목록 옵션
      list-options = "show-uid-validity";

      # 검증 옵션
      verify-options = "show-uid-validity";

      # 지문 표시
      with-fingerprint = true;

      # 상호 인증 요구
      require-cross-certification = true;

      # 대칭키 캐시 비활성화
      no-symkey-cache = true;

      # GPG 에이전트 사용
      use-agent = true;
    };

    # 스마트카드 데몬 설정
    scdaemonSettings = {
      # CCID 드라이버 비활성화 예시
      disable-ccid = true;
    };

    # 공개키 가져오기 설정
    publicKeys = [
      # 파일에서 키 가져오기
      # {
      #   source = ./pubkeys/work_key.gpg;
      #   # 신뢰도 설정 (1=unknown, 2=never, 3=marginal, 4=full, 5=ultimate)
      #   trust = "full"; # 또는 숫자로 4
      # }
      # 텍스트로 키 가져오기
      # {
      #   text = ''
      #     -----BEGIN PGP PUBLIC KEY BLOCK-----

      #     mQINBGRx8JoBEADJdP7i9q8/a0hY4aNWJbHlW/9uHKUv3YOmgh6OvwQJ90GZ5A9Y
      #     ... (키 내용) ...
      #     -----END PGP PUBLIC KEY BLOCK-----
      #   '';
      #   trust = "marginal"; # 또는 숫자로 3
      # }
    ];
  };
}
