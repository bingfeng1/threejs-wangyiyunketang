import { createRouter, createWebHashHistory } from "vue-router";


const modules = import.meta.glob("pages/allLesson/*/*.vue")

const _routes = []
for (const [key, value] of Object.entries(modules)) {
    const parent = key.replace("/src/pages/allLesson", "")
    const index1 = parent.split('/')[1]
    const index1_encode = encodeURI(parent.split('/')[1])
    const index2 = parent.split('/')[2].replace(".vue", "")
    // 转换刷新中文无法获取路径问题
    const index2_encode = encodeURI(parent.split('/')[2].replace(".vue", ""))

    const route = _routes.find(({ name }) => name === index1)
    if (route) {
        route.children.push({
            path: index2_encode,
            name: index2,
            path2: '/' + index1_encode + '/' + index2_encode,
            component: value
        })
    } else {
        _routes.push({
            path: "/" + index1_encode,
            name: index1,
            component: () => import('pages/NoOverflow.vue'),
            children: [{
                path: index2_encode,
                name: index2,
                path2: '/' + index1_encode + '/' + index2_encode,
                component: value
            }]
        })
    }
}

// 目录排序（给前端展示使用，不然顺序太乱了）
_routes.sort((a, b) => {
    let reg = /\d+/
    let a_num = (a.name).match(reg)
    let b_num = (b.name).match(reg)

    return a_num - b_num
})

_routes.forEach(({ children }) => {
    children.sort((a, b) => {
        let reg = /\d+/
        let a_num = (a.name).match(reg)
        let b_num = (b.name).match(reg)

        return a_num - b_num
    })
})

_routes.reverse()

// 路由配置，与menu共用
const routes = [
    {
        path: '/',
        redirect: _routes[_routes.length - 1].children[0].path2
    },
    ..._routes
]

const router = createRouter({
    history: createWebHashHistory(),
    // 提取本路由需要的内容
    routes
})

export { router, _routes }