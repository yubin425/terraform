**readme 수정중**
# Terraform 기반 AWS 인프라 구축

이 저장소는 AWS 환경에서 웹호스팅 인프라를 Terraform으로 구축하는 구성을 담고 있습니다. 
S3 정적 웹사이트, Kubernetes 클러스터에 배포된 백엔드 서비스(ArgoCD를 통한 GitOps 방식), RDS(MySQL) 인스턴스를 이용한 3 tier 구성으로 이루어져 있습니다. 

## 아키텍처 구조 및 설계 이유

### 아키텍처 구성 요소
- **FE, S3 정적 웹사이트:**  
  - 프론트엔드 애플리케이션을 정적 호스팅하여 비용 효율적이며 관리 부담이 적습니다.

- **BE, eks:**  
  - Docker 컨테이너 형태로 Kubernetes 클러스터에 배포됩니다.
  - ArgoCD + Github를 통해 매니페스트가 GitOps 방식으로 자동 배포되며 코드 변경 시 자동 동기화 및 롤백이 가능합니다.
  - 끝말잇기 게임 로직을 처리하고 RDS와 연동하여 게임 로그를 저장합니다.

- **RDS (MySQL):**  
  - 관리형 관계형 데이터베이스 서비스로, 백엔드 애플리케이션의 데이터를 안정적으로 저장합니다.
  - 데이터 백업 및 복구, 고가용성 등의 기능을 제공하여 운영 부담을 줄입니다.

- **ArgoCD:**  
  - GitOps 기반의 CI/CD를 구축하여 코드와 인프라 변경 사항을 자동으로 동기화합니다.
 
### 아키텍처 설계 이유


### 아키텍처 장단점, 사용량에 따른 예상 비용
