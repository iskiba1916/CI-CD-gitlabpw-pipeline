# Wdrożenie pipeline'u CI/CD w środowisku GitLab PW w podejściu GitOps

> **Infrastracture as Code (IaC)**  
> Projekt zrealizowany w ramach przedmiotu **Platformy Chmurowe dla Systemów Teleinformatycznych (PLAST) w semestrze 26L**  
> Wydział Elektroniki i Technik Informacyjnych, Politechnika Warszawska

---

## 👥 Autorzy

Igor Skiba, Radosław Rytel-Kuc

 **Data:** 24 kwietnia 2026

---

## 📋 Opis projektu

W ramach projektu wdrożono czteroetapowy pipeline'u CI/CD (validate, plan, apply, configure) z użyciem Terraform do budowania infrastruktury i Ansible do konfiguracji klastra.


---

## 🚀 Etapy realizacji

### Etap 1 — Stowrzenie GitLab Runnera

Na stworzonej wcześniej maszynie Runner zainstalowano oprogramowanie Docker oraz GitLab Runner, a następnie
połączono go z uczelnianym GitLabem.

### Etap 2 — Skonfigurowanie API i klucza SSH

Zabezpieczono dane uwierzytelniające do API OpenStack jako ukryte zmienne środowiskowe, a także skonfigurowano
udostępnianie klucza SSH.

### Etap 3 — Opracowanie .gitlab-ci.yml

Opracowano plik .gitlab-ci.yml wykorzystujący obraz gitlab-terraform oraz wykonano migrację lokalnego
pliku stanu (.tfstate) bezpośrednio na serwery GitLaba.

### Etap 4 - Skonfigurowanie czteroetapowego pipeline'u

Zdefiniowano czteroetapowy pipeline (validate, plan, apply, configure). W zaimplementowanym procesie,
zaraz po powołaniu maszyn, adresy są generowane do pliku inwentarza i przesyłane do etapu configure z
wykorzystaniem mechanizmu GitLab Artifacts, zamykając bezobsługowy proces powoływania klastra reagujący
na git push.

---

## 🧪 Wyniki testów

Poprawność wdrożenia dodatkowej części po uruchomieniu pipeline’u w Gitlabie zweryfikowano na węźle master poleceniami
kubectl get nodes oraz kubectl get pods -A. Węzły master i worker-1 osiągnęły status Ready. Instancja Runner, działająca
poza klastrem, pozostawała aktywna i podłączona do GitLaba.

---

## 💡 Wnioski

Utworzone środowisko stało się w pełni zautomatyzowane i odtwarzalne. W przypadku awarii węzłów lub innego błędu
klastra, integracja Terraforma z Ansible pozwala zburzyć infrastrukturę a następnie odbudować ją z poziomu pipeline’u
CI/CD za pomocą instancji Runnera działającego jako odrębna maszyna wirtualna.
