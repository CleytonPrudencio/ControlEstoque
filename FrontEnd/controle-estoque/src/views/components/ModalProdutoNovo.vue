<template lang="pug">
  .modal-backdrop(@click.self="fechar")
    .modal-container(role="dialog" aria-modal="true" tabindex="-1" ref="modal")
      header.modal-header
        h3 Novo Produto
        button.btn-close(@click="fechar" aria-label="Fechar modal") &times;
      section.modal-body
        form(@submit.prevent="salvar")
          label Nome
          input(type="text" v-model="produtoEditado.descricao" required)
          label Código
          input(
            type="text"
            v-model="produtoEditado.codigo"
            :disabled="isNovoProduto"
            required
          )
          label Tipo
          select(v-model="produtoEditado.tipo" required)
            option(value="ELETRONICO") Eletrônico
            option(value="ELETRODOMESTICO") Eletrodoméstico
            option(value="MOVEL") Móvel
          label Valor Fornecedor (R$)
          input(
            type="text"
            v-model="valorDigitado"
            @blur="aoSairCampoValor"
            @focus="aoEntrarCampoValor"
            required
          )

          label Quantidade
          input(type="number" v-model.number="produtoEditado.quantidadeEstoque" min="0" required)
          footer.modal-footer
            button.btn-cancel(type="button" @click="fechar") Cancelar
            button.btn-save(type="submit") Salvar
  </template>

<script setup lang="ts">
import { defineEmits, defineProps, reactive, ref, watch, onMounted, computed } from 'vue'
import { pegarNovoCodigo } from '@/services/produtoService'
interface Produto {
  codigo: string
  descricao: string
  tipoProduto: TipoProduto
  quantidadeEstoque: number
  valorFornecedor: number
}
const isNovoProduto = ref(false)

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'salvar', produto: Produto): void
}>()

const props = defineProps<{
  produto: Produto | null
}>()
type TipoProduto = 'ELETRONICO' | 'ELETRODOMESTICO' | 'MOVEL'

const produtoEditado = reactive<Produto>({
  codigo: '',
  descricao: '',
  tipoProduto: 'ELETRONICO',
  quantidadeEstoque: 0,
  valorFornecedor: 0
})
const valorDigitado = ref('')

onMounted(() => {
  valorDigitado.value = formatarMoeda(produtoEditado.valorFornecedor)
})

watch(
  () => produtoEditado.valorFornecedor,
  (novo) => {
    valorDigitado.value = formatarMoeda(novo)
  }
)

function aoEntrarCampoValor() {
  valorDigitado.value = produtoEditado.valorFornecedor.toString().replace('.', ',')
}

function aoSairCampoValor() {
  const valorNumerico = parseMoeda(valorDigitado.value)
  produtoEditado.valorFornecedor = valorNumerico
  valorDigitado.value = formatarMoeda(valorNumerico)
}

const valorFornecedorFormatado = computed({
  get() {
    return formatarMoeda(produtoEditado.valorFornecedor)
  },
  set(valor: string) {
    produtoEditado.valorFornecedor = parseMoeda(valor)
  }
})
onMounted(async () => {
  if (props.produto) {
    Object.assign(produtoEditado, props.produto)
    atualizarFormatacoes()
    isNovoProduto.value = false
  } else {
    isNovoProduto.value = true
    produtoEditado.codigo = await pegarNovoCodigo()
  }
})

watch(
  () => props.produto,
  async (novo) => {
    if (novo) {
      Object.assign(produtoEditado, novo)
      atualizarFormatacoes()
      isNovoProduto.value = false
    } else {
      isNovoProduto.value = true
      produtoEditado.codigo = await pegarNovoCodigo()
    }
  },
  { immediate: true }
)

watch(
  () => produtoEditado.valorFornecedor,
  () => {
    valorFornecedorFormatado.value = formatarMoeda(produtoEditado.valorFornecedor)
  }
)

function atualizarFormatacoes() {
  valorFornecedorFormatado.value = formatarMoeda(produtoEditado.valorFornecedor)
}
function parseMoeda(valor: string): number {
  const limpo = valor.replace(/[^\d,]/g, '').replace(',', '.')
  return parseFloat(limpo) || 0
}

function formatarMoeda(valor: number): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
    minimumFractionDigits: 2
  }).format(valor)
}

function aoDigitarValorFornecedor(event: Event) {
  const alvo = event.target as HTMLInputElement
  produtoEditado.valorFornecedor = parseMoeda(alvo.value)
  valorFornecedorFormatado.value = formatarMoeda(produtoEditado.valorFornecedor)
}

function fechar() {
  emit('close')
}

function salvar() {
  emit('salvar', { ...produtoEditado })
  fechar()
}
</script>
<style scoped>
.modal-backdrop {
  position: fixed;
  inset: 0;
  background-color: rgba(100, 100, 100, 0.4);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1100;
}

.modal-container {
  background: #fff;
  border-radius: 16px;
  max-width: 500px;
  width: 95%;
  padding: 2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.modal-header h3 {
  font-size: 1.5rem;
  color: #2c3e50;
  font-weight: bold;
  margin: 0;
}

.btn-close {
  background: none;
  border: none;
  font-size: 2rem;
  line-height: 1;
  cursor: pointer;
  color: #777;
  transition: color 0.2s ease;
}

.btn-close:hover {
  color: #000;
}

.modal-body {
  flex: 1;
  display: flex;
  flex-direction: column;
}

label {
  font-weight: 600;
  color: #000;
  margin-top: 1rem;
  display: block;
  font-size: 0.95rem;
}

input,
select {
  width: 100%;
  padding: 0.6rem 0.75rem;
  margin-top: 0.3rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 1rem;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #ffffff;
  transition:
    border-color 0.3s ease,
    background-color 0.3s ease;
}

input:focus,
select:focus {
  outline: none;
  border-color: #42b983;
  background-color: #fff;
}

/* Estilos específicos para campos de valor */
input[v-model='produtoEditado.valorFornecedor'] {
  border-left: 4px solid #2980b9;
}

input[v-model='produtoEditado.valorVenda'] {
  border-left: 4px solid #27ae60;
}

/* Rodapé do modal */
.modal-footer {
  margin-top: 2rem;
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
}

.btn-cancel {
  background-color: #eee;
  border: none;
  padding: 0.6rem 1.4rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  color: #555;
  transition: background-color 0.2s ease;
}

.btn-cancel:hover {
  background-color: #ddd;
}

.btn-save {
  background-color: #42b983;
  border: none;
  padding: 0.6rem 1.6rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 700;
  color: white;
  transition: background-color 0.2s ease;
}

.btn-save:hover {
  background-color: #369b70;
}
</style>
