<script setup>
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://vuejs.org/api/sfc-script-setup.html#script-setup
import { _routes } from './routes';

</script>

<template>
  <el-container class="container">
    <el-aside width="200px" class="aside">
      <el-scrollbar>
        <el-menu default-active="2" class="el-menu-vertical-demo" :router="true">
          <template v-for="route in _routes" :key="route.path">
            <el-sub-menu :index="route.path">
              <template #title>
                <span>{{ route.name }}</span>
              </template>
              <el-menu-item v-for="({ path2, name }) in route.children" :index="path2">{{ name }}
              </el-menu-item>
            </el-sub-menu>
          </template>
        </el-menu>
      </el-scrollbar>
    </el-aside>
    <el-main style="position: relative;">
      <router-view></router-view>
    </el-main>
  </el-container>
</template>

<style scoped>
.aside {
  min-height: 100vh;
  background-color: rgb(195, 233, 238);
}
</style>
