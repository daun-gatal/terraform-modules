<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { withBase } from 'vitepress'
import modules from '../data/modules.json'
import inventory from '../data/inventory.json'

const props = defineProps({
  viewMode: {
    type: String,
    default: 'all' // 'all' | 'showcase'
  }
})

// Extract categories dynamically from the inventory keys
const categories = Object.keys(inventory)

const activeCategoryIndex = ref(0)
const progress = ref(0)
const isPaused = ref(false)
let timer = null
let progressInterval = null

const CYCLE_DURATION = 5000 // 5 seconds per category
const UPDATE_FREQ = 50 // Update progress every 50ms

const activeCategory = computed(() => categories[activeCategoryIndex.value])

const filteredModules = computed(() => {
  if (props.viewMode === 'all') {
    return modules
  }
  return modules.filter(m => m.category === activeCategory.value)
})

const startCycle = () => {
  if (props.viewMode !== 'showcase') return

  // Clear existing timers
  clearInterval(timer)
  clearInterval(progressInterval)

  // Start progress ticker
  progress.value = 0
  progressInterval = setInterval(() => {
    if (!isPaused.value) {
      progress.value += (UPDATE_FREQ / CYCLE_DURATION) * 100
      if (progress.value >= 100) {
        progress.value = 0
        nextCategory()
      }
    }
  }, UPDATE_FREQ)
}

const nextCategory = () => {
  activeCategoryIndex.value = (activeCategoryIndex.value + 1) % categories.length
}

const setCategory = (index) => {
  activeCategoryIndex.value = index
  progress.value = 0
}

onMounted(() => {
  startCycle()
})

onUnmounted(() => {
  clearInterval(timer)
  clearInterval(progressInterval)
})
</script>

<template>
  <div class="explorer-container" @mouseenter="isPaused = true" @mouseleave="isPaused = false">
    
    <!-- SHOCASE MODE: Header & Transition Grid -->
    <template v-if="viewMode === 'showcase'">
      <div class="category-header">
        <div class="controls-wrapper">
          <div class="indicators">
            <button 
              v-for="(cat, index) in categories" 
              :key="cat"
              class="indicator-dot"
              :class="{ active: index === activeCategoryIndex }"
              @click="setCategory(index)"
              :title="cat"
            ></button>
          </div>
        </div>
        
        <div class="progress-bar">
          <div class="progress-fill" :style="{ width: `${progress}%` }"></div>
        </div>
      </div>

      <Transition name="slide-hoz" mode="out-in">
        <div class="grid" :key="activeCategoryIndex">
          <a 
            v-for="mod in filteredModules" 
            :key="mod.name" 
            :href="withBase(mod.link)"
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
      </Transition>
    </template>

    <!-- ALL MODE: Simple Grid -->
    <template v-else>
      <div class="grid">
        <a 
          v-for="mod in filteredModules" 
          :key="mod.name" 
          :href="withBase(mod.link)"
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
    </template>
  </div>
</template>

<style scoped>
.explorer-container {
  margin: 4rem 0;
  position: relative;
  overflow: hidden; /* Prevent scrollbars during transition */
}

/* Category Header Styles */
.category-header {
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  /* Remove border for cleaner look? Keeping it for now as separation */
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.controls-wrapper {
  display: flex;
  justify-content: center;
  margin-bottom: 1rem;
}

.indicators {
  display: flex;
  gap: 12px; /* Increased gap for better touch targets */
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 20px;
}

.indicator-dot {
  width: 10px; /* Slightly larger */
  height: 10px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

.indicator-dot:hover {
  background: rgba(255, 255, 255, 0.5);
  transform: scale(1.1);
}

.indicator-dot.active {
  background: var(--vp-c-brand-1);
  box-shadow: 0 0 10px var(--vp-c-brand-1);
  transform: scale(1.1);
}

.progress-bar {
  height: 2px;
  background: rgba(255, 255, 255, 0.05);
  margin-top: 0.5rem;
  border-radius: 2px;
  overflow: hidden;
  max-width: 200px; /* Limit width */
  margin-left: auto;
  margin-right: auto;
}

.progress-fill {
  height: 100%;
  background: var(--vp-c-brand-1);
  transition: width 0.05s linear;
}

/* Grid & Card Styles */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
  min-height: 200px;
}

/* Horizontal Slide Transition */
.slide-hoz-enter-active,
.slide-hoz-leave-active {
  transition: all 0.5s ease-in-out;
}

.slide-hoz-enter-from {
  opacity: 0;
  transform: translateX(100px); /* Enter from Right */
}

.slide-hoz-leave-to {
  opacity: 0;
  transform: translateX(-100px); /* Leave to Left */
}


.module-card {
  background: rgba(255, 255, 255, 0.03);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  padding: 1.5rem;
  display: block;
  position: relative; /* Context for absolute icon */
  text-decoration: none !important;
  color: inherit;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  min-height: 160px; /* Ensure minimum height for large icon */
}

.module-card:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.08);
  box-shadow: 0 10px 30px -10px rgba(255, 129, 63, 0.3);
  border-color: var(--vp-c-brand-1);
}

.icon {
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  font-size: 4rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 96px;
  height: 96px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 16px;
  padding: 12px;
  transition: background 0.3s ease, transform 0.3s ease;
}

.module-card:hover .icon {
  background: rgba(255, 255, 255, 0.1);
  transform: scale(1.05) rotate(5deg);
}

.img-icon {
    width: 100%;
    height: 100%;
    object-fit: contain;
    filter: drop-shadow(0 2px 4px rgba(0,0,0,0.2));
}

.info {
  margin-right: 100px; /* Space for the icon */
}

.info h3 {
  margin: 0;
  font-size: 1.5rem; /* Slightly larger title */
  font-weight: 600;
  color: var(--vp-c-text-1);
}

.info p {
  margin: 0.5rem 0 0;
  font-size: 0.95rem;
  color: var(--vp-c-text-2);
  line-height: 1.5;
}
</style>
