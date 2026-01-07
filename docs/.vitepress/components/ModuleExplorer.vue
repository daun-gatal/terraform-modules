<script setup>
import { ref, computed } from 'vue'
import modules from '../data/modules.json'
import inventory from '../data/inventory.json'

// Extract categories dynamically from the inventory keys
// We prepend 'All' manually.
const categories = ['All', ...Object.keys(inventory)]

const activeCategory = ref('All')
const searchQuery = ref('')

const filteredModules = computed(() => {
  return modules.filter(m => {
    const matchesCategory = activeCategory.value === 'All' || m.category === activeCategory.value
    const matchesSearch = m.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchesCategory && matchesSearch
  })
})
</script>

<template>
  <div class="explorer-container">
    <div class="controls">
      <div class="tabs">
        <button 
          v-for="cat in categories" 
          :key="cat"
          :class="{ active: activeCategory === cat }"
          @click="activeCategory = cat"
        >
          {{ cat }}
        </button>
      </div>
      <div class="search-box">
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="Search modules..."
        >
      </div>
    </div>

    <div class="grid">
      <a 
        v-for="mod in filteredModules" 
        :key="mod.name" 
        :href="mod.link"
        class="module-card"
      >
        <div class="icon">
             <img v-if="mod.icon.startsWith('http') || mod.icon.includes('/')" :src="mod.icon" :alt="mod.name" class="img-icon" />
             <span v-else>{{ mod.icon }}</span>
        </div>
        <div class="info">
          <h3>{{ mod.name }}</h3>
          <p>{{ mod.desc }}</p>
        </div>
      </a>
    </div>
  </div>
</template>

<style scoped>
.explorer-container {
  margin: 4rem 0;
}

.controls {
  margin-bottom: 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  align-items: center;
}

.tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  justify-content: center;
}

button {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  padding: 0.5rem 1rem;
  border-radius: 20px;
  color: var(--vp-c-text-2);
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: var(--vp-font-family-base);
}

button:hover, button.active {
  background: var(--vp-c-brand-1);
  color: white;
  border-color: var(--vp-c-brand-1);
}

.search-box input {
  background: rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  padding: 0.75rem 1.5rem;
  border-radius: 12px;
  width: 300px;
  color: white;
  backdrop-filter: blur(10px);
}

.search-box input:focus {
  outline: none;
  border-color: var(--vp-c-brand-1);
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.module-card {
  background: rgba(255, 255, 255, 0.03);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  text-decoration: none !important;
  color: inherit;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.module-card:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.08);
  box-shadow: 0 10px 30px -10px rgba(255, 129, 63, 0.3);
  border-color: var(--vp-c-brand-1);
}

.icon {
  font-size: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  padding: 8px;
  transition: background 0.3s ease;
}

.module-card:hover .icon {
  background: rgba(255, 255, 255, 0.1);
}

.img-icon {
    width: 100%;
    height: 100%;
    object-fit: contain;
    filter: drop-shadow(0 2px 4px rgba(0,0,0,0.2));
}

.info h3 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
  color: var(--vp-c-text-1);
}

.info p {
  margin: 0.25rem 0 0;
  font-size: 0.9rem;
  color: var(--vp-c-text-2);
}
</style>
