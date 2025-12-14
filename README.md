# 刷机匣高通资源包

本仓库用于存放刷机匣的高通 EDL 资源包，并会每日自动从上游仓库同步最新内容。

## 仓库简介
- 收录各品牌高通设备的 EDL 资源文件，方便刷机匣快速查找使用。
- 通过 GitHub Actions（.github/workflows/sync-upstream.yml）在每天 UTC 0 点自动同步上游，保持内容最新。

## 发布流程
1. 修改Config.xml
2. 添加文件
3. 通过publish.ps1发布成压缩包

XML格式请看 "Config.xml"

### 发布脚本
```.\publish.ps1 作者 版本号 包说明``` 
```.\publish.ps1 Jackson 1.0.0 测试资源包``` 
