import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'
function _path(...src) {
  return path.resolve(__dirname, ...src)
}

// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      'views': _path('./src/views'),
      apis: _path('src/api'),
      comps: _path('src/components'),
      pages: _path('src/pages'),
      utils: _path('src/utils'),
      '@': _path('src')
    }
  },
  plugins: [vue()]
})
