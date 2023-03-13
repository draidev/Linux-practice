# Linux-practice   

```sed```   
Stream Editor의 약자로 원본 텍스트 파일을 편집할 수 있는 명령어.   
- 단어 치환(Substitute) - s   
```
sed 's/old/new/g' file
sed -i 's/ */ /g' file
```	   
->g플래그는 치환이 행 전체를 대상으로 함   


## service   
- Type : oneshot 옵션과 Restart : always 옵션은 충돌난다.   