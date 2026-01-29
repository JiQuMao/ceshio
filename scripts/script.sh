# 固件名称 & 编译时间
#sed -i "s/hostname='.*'/hostname='ER1'/g" package/base-files/files/bin/config_generate
#sed -i "s#_('Firmware Version'), (L\.isObject(boardinfo\.release) ? boardinfo\.release\.description + ' / ' : '') + (luciversion || ''),# \
#            E('span', {}, [\n \
#                (L.isObject(boardinfo.release)\n \
#                ? boardinfo.release.description + ' / '\n \
#                : '') + (luciversion || '') + ' / ',\n \
#            ]),#" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

# 移除luci-app-attendedsysupgrade软件包
sed -i "/attendedsysupgrade/d" $(find ./feeds/luci/collections/ -type f -name "Makefile")

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

./scripts/feeds update -a
./scripts/feeds install -a
